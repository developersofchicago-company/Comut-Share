// OGRA petrol price scraper.
//
// Fetches the latest petrol notification from OGRA (Oil & Gas Regulatory Authority).
// OGRA publishes rate revisions on the 1st and 16th of each month.
//
// Source: https://www.ogra.org.pk/notifications  (HTML scrape — they don't expose JSON)
// Fallback source: News scrape from DAWN's petrol-price ticker.
//
// On each successful fetch we INSERT INTO ogra_rates ON CONFLICT (effective_date) DO NOTHING,
// so re-runs are idempotent. The PricingService reads the latest rate from this table.

import { supabaseAdmin } from '../db/supabase.client';

const OGRA_URL = process.env.OGRA_NOTIFICATIONS_URL || 'https://www.ogra.org.pk/notifications';
const FALLBACK_URL = process.env.FALLBACK_PETROL_URL || ''; // optional

export interface PetrolRate {
  rate: number;
  effective_date: string; // YYYY-MM-DD
  source: string;
}

/**
 * Parse a rate from raw HTML.
 * OGRA pages typically include text like:
 *   "Notification No. ... Petrol (MS) ... Rs. 409.78/litre w.e.f. 16-05-2026"
 * We use a tolerant regex; if OGRA changes their format the regex needs updating.
 */
function parseRateFromHtml(html: string): PetrolRate | null {
  // Strip HTML tags so the regex isn't fighting markup
  const text = html.replace(/<[^>]+>/g, ' ').replace(/\s+/g, ' ');

  // Match Rs. X(.XX) per litre near the word Petrol/MS
  const rateMatch = text.match(/Petrol[^0-9]*(?:MS)?[^0-9]*Rs\.?\s*(\d{2,4}(?:\.\d{1,2})?)\s*\/?\s*(?:per\s+)?litre/i);
  // Match date w.e.f. DD-MM-YYYY or DD/MM/YYYY
  const dateMatch = text.match(/w\.e\.f\.?\s*(\d{1,2})[-\/](\d{1,2})[-\/](\d{4})/i);

  if (!rateMatch) return null;
  const rate = parseFloat(rateMatch[1]);
  if (isNaN(rate) || rate < 100 || rate > 2000) return null; // sanity guard

  let effectiveDate = new Date().toISOString().slice(0, 10);
  if (dateMatch) {
    const dd = dateMatch[1].padStart(2, '0');
    const mm = dateMatch[2].padStart(2, '0');
    const yyyy = dateMatch[3];
    effectiveDate = `${yyyy}-${mm}-${dd}`;
  }

  return { rate, effective_date: effectiveDate, source: 'OGRA' };
}

export class OgraScraper {
  static async fetchLatest(): Promise<PetrolRate | null> {
    const urls = [OGRA_URL, FALLBACK_URL].filter(Boolean);
    for (const url of urls) {
      try {
        console.log(`[ogra] fetching ${url}`);
        const res = await fetch(url, {
          headers: { 'User-Agent': 'ComutShare-Scraper/1.0 (+inquiry@developersofchicago.com)' },
        });
        if (!res.ok) {
          console.warn(`[ogra] ${url} returned ${res.status}`);
          continue;
        }
        const html = await res.text();
        const parsed = parseRateFromHtml(html);
        if (parsed) {
          console.log(`[ogra] parsed Rs. ${parsed.rate}/L effective ${parsed.effective_date}`);
          return parsed;
        }
        console.warn(`[ogra] could not parse rate from ${url}`);
      } catch (err: any) {
        console.error(`[ogra] error fetching ${url}: ${err.message}`);
      }
    }
    return null;
  }

  static async upsertRate(rate: PetrolRate) {
    const { error } = await supabaseAdmin
      .from('ogra_rates')
      .upsert(
        { rate: rate.rate, effective_date: rate.effective_date },
        { onConflict: 'effective_date' }
      );
    if (error) throw new Error(`Failed to upsert ogra_rate: ${error.message}`);
  }

  /** Get the currently active petrol price (latest effective_date <= today). */
  static async getCurrentRate(): Promise<number> {
    const today = new Date().toISOString().slice(0, 10);
    const { data, error } = await supabaseAdmin
      .from('ogra_rates')
      .select('rate, effective_date')
      .lte('effective_date', today)
      .order('effective_date', { ascending: false })
      .limit(1)
      .maybeSingle();

    if (error) throw new Error(error.message);
    return data ? Number(data.rate) : 409.78; // fallback to anchored default
  }

  /** Main entry point — called by cron or manually. */
  static async runOnce(): Promise<{ updated: boolean; rate?: PetrolRate }> {
    const fresh = await this.fetchLatest();
    if (!fresh) return { updated: false };
    await this.upsertRate(fresh);
    return { updated: true, rate: fresh };
  }
}

// ── Cron scheduler ────────────────────────────────────
// Runs every day at 02:00 Asia/Karachi (PKT). The 1st and 16th are the days
// OGRA updates rates; we poll daily to be resilient to off-schedule changes.
export function startOgraCron() {
  const ONE_DAY_MS = 24 * 60 * 60 * 1000;
  const runAndSchedule = async () => {
    try {
      const result = await OgraScraper.runOnce();
      if (result.updated) {
        console.log(`[ogra-cron] updated rate to Rs. ${result.rate?.rate} effective ${result.rate?.effective_date}`);
      }
    } catch (err: any) {
      console.error(`[ogra-cron] failed: ${err.message}`);
    }
  };

  // First run on startup, then daily
  runAndSchedule();
  setInterval(runAndSchedule, ONE_DAY_MS);
  console.log('[ogra-cron] scheduled daily OGRA rate check');
}
