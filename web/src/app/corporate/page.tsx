"use client";

import { useEffect, useState } from "react";
import { createClient } from "@supabase/supabase-js";

// INTEGRATION POINT: real auth would identify the HR user's company.
// For MVP we hard-code HBL — replace with auth.user → company_id lookup.
const DEMO_COMPANY_ID = "00000000-0000-0000-0000-000000000000"; // replace post-auth

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const supabase = supabaseUrl && supabaseAnonKey ? createClient(supabaseUrl, supabaseAnonKey) : null;

interface OverviewStats {
  employeeCount: number;
  ridesThisMonth: number;
  fuelSavedRs: number;
  co2SavedKg: number;
}

export default function CorporateOverview() {
  const [stats, setStats] = useState<OverviewStats>({
    employeeCount: 0,
    ridesThisMonth: 0,
    fuelSavedRs: 0,
    co2SavedKg: 0,
  });
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    async function loadStats() {
      if (!supabase) {
        // Fallback demo numbers when Supabase isn't configured
        setStats({
          employeeCount: 47,
          ridesThisMonth: 312,
          fuelSavedRs: 286400,
          co2SavedKg: 894,
        });
        setIsLoading(false);
        return;
      }
      try {
        // Real query — counts employees by company_id
        // (Will fail silently until DEMO_COMPANY_ID is wired to actual auth)
        const { count: empCount } = await supabase
          .from("users")
          .select("*", { count: "exact", head: true })
          .eq("company_id", DEMO_COMPANY_ID);

        const firstOfMonth = new Date();
        firstOfMonth.setDate(1);
        firstOfMonth.setHours(0, 0, 0, 0);

        const { count: rideCount } = await supabase
          .from("rides")
          .select("*", { count: "exact", head: true })
          .gte("created_at", firstOfMonth.toISOString());

        // Aggregate fuel savings: each ride saves ~Rs 600 vs Careem for 20km/22 days riders
        // INTEGRATION POINT: compute from real bookings × pricing math
        const estimatedSavings = (rideCount ?? 0) * 600;
        const estimatedCo2 = (rideCount ?? 0) * 2.8; // ~2.8 kg CO2 saved per shared ride

        setStats({
          employeeCount: empCount ?? 0,
          ridesThisMonth: rideCount ?? 0,
          fuelSavedRs: estimatedSavings,
          co2SavedKg: Math.round(estimatedCo2),
        });
      } catch (e) {
        console.error("Failed to load stats:", e);
      } finally {
        setIsLoading(false);
      }
    }
    loadStats();
  }, []);

  const cards = [
    { label: "Verified Employees", value: stats.employeeCount.toLocaleString(), accent: "text-white", icon: "👥" },
    { label: "Rides This Month", value: stats.ridesThisMonth.toLocaleString(), accent: "text-white", icon: "🚗" },
    { label: "Fuel Saved (Rs.)", value: `Rs. ${stats.fuelSavedRs.toLocaleString()}`, accent: "text-[#A6CE39]", icon: "⛽" },
    { label: "CO₂ Offset (kg)", value: `${stats.co2SavedKg.toLocaleString()} kg`, accent: "text-[#A6CE39]", icon: "🌿" },
  ];

  return (
    <div className="space-y-8">
      {/* Hero card */}
      <div className="relative overflow-hidden rounded-2xl border border-[#1E1E1E] bg-gradient-to-br from-[#0F0F0F] to-[#0A0A0A] p-8">
        <div className="absolute top-0 right-0 w-48 h-48 bg-[#A6CE39]/5 rounded-full blur-3xl pointer-events-none" />
        <div className="relative space-y-2">
          <span className="text-xs uppercase font-bold tracking-widest text-slate-500">Corporate HR Workspace</span>
          <h2 className="text-2xl sm:text-3xl font-extrabold text-white">Your team's commute, at a glance</h2>
          <p className="text-slate-400 text-sm max-w-xl">
            Track how many of your employees are saving on petrol, reducing parking pressure, and arriving on time —
            with no extra friction for HR.
          </p>
        </div>
      </div>

      {/* Stat cards */}
      <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {cards.map((c) => (
          <div key={c.label} className="rounded-2xl border border-[#1E1E1E] bg-[#0F0F0F] p-6 space-y-3">
            <div className="flex items-center justify-between">
              <span className="text-xs uppercase font-bold tracking-wider text-slate-500">{c.label}</span>
              <span className="text-2xl">{c.icon}</span>
            </div>
            <div className={`text-2xl font-extrabold ${c.accent}`}>
              {isLoading ? "—" : c.value}
            </div>
          </div>
        ))}
      </div>

      {/* Top routes table */}
      <div className="rounded-2xl border border-[#1E1E1E] bg-[#0F0F0F] overflow-hidden">
        <div className="p-6 border-b border-[#1E1E1E] flex items-center justify-between">
          <h3 className="font-bold text-white">Most Popular Routes</h3>
          <span className="text-xs text-slate-500">This month</span>
        </div>
        <div className="divide-y divide-[#1E1E1E]">
          {[
            { route: "DHA Phase 6 → Shahrah-e-Faisal", riders: 28, savings: "Rs. 84,000" },
            { route: "Gulshan-e-Iqbal → I.I. Chundrigar Road", riders: 19, savings: "Rs. 57,000" },
            { route: "Clifton Block 5 → Korangi Industrial", riders: 14, savings: "Rs. 42,000" },
            { route: "North Nazimabad → Shahrah-e-Faisal", riders: 11, savings: "Rs. 33,000" },
          ].map((r) => (
            <div key={r.route} className="px-6 py-4 flex items-center justify-between hover:bg-[#1A1A1A]/40">
              <div>
                <span className="block font-semibold text-sm text-white">{r.route}</span>
                <span className="text-xs text-slate-500">{r.riders} active riders</span>
              </div>
              <span className="font-bold text-[#A6CE39]">{r.savings}</span>
            </div>
          ))}
        </div>
      </div>

      {/* Pilot CTA */}
      <div className="rounded-2xl border border-[#A6CE39]/20 bg-[#A6CE39]/5 p-6 flex items-center justify-between">
        <div>
          <h3 className="font-bold text-white text-lg">Ready to roll out company-wide?</h3>
          <p className="text-sm text-slate-400 mt-1">Activate full enterprise subsidy controls and SSO.</p>
        </div>
        <a
          href="mailto:inquiry@developersofchicago.com?subject=Activate%20ComutShare%20Enterprise"
          className="bg-[#A6CE39] hover:bg-[#92b532] text-black font-extrabold px-6 py-3 rounded-xl text-sm transition-all"
        >
          Contact Sales
        </a>
      </div>
    </div>
  );
}
