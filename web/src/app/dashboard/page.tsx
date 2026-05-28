"use client";

import React, { useState } from "react";
import Link from "next/link";

export default function DashboardOverview() {
  const [role, setRole] = useState<"rider" | "driver">("rider");

  return (
    <div className="space-y-8">
      {/* Welcome Card */}
      <div className="relative overflow-hidden rounded-2xl border border-slate-800 bg-gradient-to-br from-slate-900 to-slate-950 p-8 shadow-xl">
        <div className="absolute top-0 right-0 w-48 h-48 bg-emerald-500/5 rounded-full blur-2xl pointer-events-none" />
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-6 relative">
          <div className="space-y-2">
            <span className="text-xs uppercase font-bold tracking-widest text-slate-500">Workspace Dashboard</span>
            <h2 className="text-2xl sm:text-3xl font-extrabold text-white">Commute Smarter, Karachi</h2>
            <p className="text-slate-400 text-sm max-w-xl">
              Switch roles, track active match pools, top-up your wallet balance, and split daily petrol burn with corporate colleagues.
            </p>
          </div>
          <div className="inline-flex p-1 rounded-xl bg-slate-950 border border-slate-800">
            <button
              onClick={() => setRole("rider")}
              className={`px-6 py-2.5 rounded-lg text-xs font-bold transition-all ${
                role === "rider"
                  ? "bg-emerald-500 text-slate-950 shadow-md shadow-emerald-500/10"
                  : "text-slate-400 hover:text-slate-200"
              }`}
            >
              Rider Portal
            </button>
            <button
              onClick={() => setRole("driver")}
              className={`px-6 py-2.5 rounded-lg text-xs font-bold transition-all ${
                role === "driver"
                  ? "bg-emerald-500 text-slate-950 shadow-md shadow-emerald-500/10"
                  : "text-slate-400 hover:text-slate-200"
              }`}
            >
              Driver Portal
            </button>
          </div>
        </div>
      </div>

      {role === "rider" ? (
        // Rider View
        <div className="grid md:grid-cols-3 gap-6">
          <div className="md:col-span-2 space-y-6">
            <div className="bg-slate-900/40 rounded-2xl border border-slate-900 p-6 space-y-6">
              <div className="flex justify-between items-center pb-4 border-b border-slate-800/60">
                <h3 className="font-bold text-base text-white">Suggested Rides For You</h3>
                <Link href="/dashboard/find-ride" className="text-xs text-emerald-400 font-bold hover:underline">
                  Search All ➔
                </Link>
              </div>

              {/* Ride Items */}
              <div className="space-y-4">
                <div className="p-4 rounded-xl border border-slate-800/80 bg-slate-950/40 flex items-center justify-between">
                  <div className="flex gap-4 items-center">
                    <div className="w-10 h-10 rounded-lg bg-emerald-500/10 text-emerald-400 flex items-center justify-center font-bold text-sm">BI</div>
                    <div>
                      <span className="block font-bold text-sm text-slate-200">Bilal Imran (Bank Manager)</span>
                      <span className="text-xs text-slate-500">DHA Phase 6 ➔ Shahrah-e-Faisal | Toyota Corolla</span>
                    </div>
                  </div>
                  <div className="text-right">
                    <span className="block font-extrabold text-white text-base">Rs. 210</span>
                    <span className="text-[10px] text-emerald-400 block font-bold">08:30 AM departure</span>
                  </div>
                </div>

                <div className="p-4 rounded-xl border border-slate-800/80 bg-slate-950/40 flex items-center justify-between">
                  <div className="flex gap-4 items-center">
                    <div className="w-10 h-10 rounded-lg bg-emerald-500/10 text-emerald-400 flex items-center justify-center font-bold text-sm">AK</div>
                    <div>
                      <span className="block font-bold text-sm text-slate-200">Ayesha Khan (Software Engineer)</span>
                      <span className="text-xs text-slate-500">Gulshan Block 4 ➔ I.I. Chundrigar Road | Suzuki Swift</span>
                    </div>
                  </div>
                  <div className="text-right">
                    <span className="block font-extrabold text-white text-base">Rs. 195</span>
                    <span className="text-[10px] text-emerald-400 block font-bold">08:45 AM departure</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Quick Info Panel */}
          <div className="space-y-6">
            <div className="bg-slate-900/40 rounded-2xl border border-slate-900 p-6 space-y-4">
              <h4 className="font-bold text-sm text-slate-400 uppercase tracking-wider">Weekly Savings</h4>
              <div className="space-y-2">
                <div className="flex justify-between items-center text-sm">
                  <span className="text-slate-500">Solo Commute cost:</span>
                  <span className="line-through text-slate-500 font-semibold">Rs. 4,100</span>
                </div>
                <div className="flex justify-between items-center text-sm">
                  <span className="text-slate-400 font-medium">ComutShare seat cost:</span>
                  <span className="text-emerald-400 font-bold">Rs. 2,100</span>
                </div>
                <div className="pt-2 border-t border-slate-800 flex justify-between items-center">
                  <span className="text-sm font-bold text-white">Net Weekly Saved:</span>
                  <span className="text-lg font-extrabold text-emerald-400">Rs. 2,000</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      ) : (
        // Driver View
        <div className="grid md:grid-cols-3 gap-6">
          <div className="md:col-span-2 space-y-6">
            <div className="bg-slate-900/40 rounded-2xl border border-slate-900 p-6 space-y-6">
              <div className="flex justify-between items-center pb-4 border-b border-slate-800/60">
                <h3 className="font-bold text-base text-white">Your Scheduled Ride Offers</h3>
                <Link href="/dashboard/post-ride" className="text-xs text-emerald-400 font-bold hover:underline">
                  Create New Ride ➔
                </Link>
              </div>

              <div className="space-y-4">
                <div className="p-4 rounded-xl border border-slate-800/80 bg-slate-950/40 flex items-center justify-between">
                  <div>
                    <span className="block font-bold text-sm text-slate-200">Karachi Commute (DHA ➔ Shahrah-e-Faisal)</span>
                    <span className="text-xs text-slate-500 font-semibold">Scheduled seats: 3 riders matching | Rs. 8/km margin</span>
                  </div>
                  <div className="text-right">
                    <span className="block font-extrabold text-white text-base">Earns Rs. 220 net</span>
                    <span className="text-[10px] text-emerald-400 block font-bold">Published</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div className="space-y-6">
            <div className="bg-slate-900/40 rounded-2xl border border-slate-900 p-6 space-y-4">
              <h4 className="font-bold text-sm text-slate-400 uppercase tracking-wider">Driver Units Economics</h4>
              <div className="space-y-2 text-sm">
                <div className="flex justify-between">
                  <span className="text-slate-500">Trip Petrol Covered:</span>
                  <span className="text-emerald-400 font-bold">100% covered</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500">Estimated profit / month:</span>
                  <span className="text-white font-bold">Rs. 4,840</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
