// Supabase server-side client singletons.
//
// Two clients are exported:
//  - supabaseAdmin: uses SERVICE_ROLE_KEY, bypasses RLS, for server-controlled writes
//      (transactions ledger, system-issued bookings, OGRA inserts, etc.)
//  - supabaseFor(token): uses the user's JWT, RLS-enforced, for read/write on behalf of user
//
// .env required:
//   SUPABASE_URL=https://epkrmxatgqjbqzrmisvy.supabase.co
//   SUPABASE_ANON_KEY=eyJhbGc...   (public, used as fallback)
//   SUPABASE_SERVICE_ROLE_KEY=eyJhbGc...  (secret, never expose to client)

import { createClient, SupabaseClient } from '@supabase/supabase-js';

const SUPABASE_URL = process.env.SUPABASE_URL || '';
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY || '';
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
  console.warn('[supabase] Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in env. Server-side ops will fail until configured.');
}

export const supabaseAdmin: SupabaseClient = createClient(
  SUPABASE_URL,
  SUPABASE_SERVICE_ROLE_KEY,
  {
    auth: { autoRefreshToken: false, persistSession: false },
  }
);

/**
 * Returns a Supabase client scoped to a single user's JWT.
 * RLS policies will apply as if the user were querying directly from the client.
 */
export function supabaseFor(userJwt: string): SupabaseClient {
  return createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
    global: { headers: { Authorization: `Bearer ${userJwt}` } },
    auth: { autoRefreshToken: false, persistSession: false },
  });
}
