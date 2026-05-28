"use client";

import React, { useState } from "react";

export default function FindRidePage() {
  const [from, setFrom] = useState("Gulshan-e-Iqbal");
  const [to, setTo] = useState("I.I. Chundrigar Road");

  return (
    <div className="space-y-8">
      <div className="bg-slate-900/40 border border-slate-900 rounded-2xl p-6">
        <h3 className="font-bold text-base text-white mb-6">Find Active Commute Matches</h3>
        <div className="grid md:grid-cols-2 gap-6">
          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-500 uppercase">Pickup Area</label>
            <input
              type="text"
              value={from}
              onChange={(e) => setFrom(e.target.value)}
              className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
            />
          </div>
          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-500 uppercase">Destination Area</label>
            <input
              type="text"
              value={to}
              onChange={(e) => setTo(e.target.value)}
              className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
            />
          </div>
        </div>
      </div>

      <div className="space-y-4">
        <h4 className="font-bold text-sm text-slate-400 uppercase tracking-wider">Matching Commutes</h4>
        <div className="p-5 rounded-2xl border border-slate-800 bg-slate-900/20 flex flex-col md:flex-row md:items-center justify-between gap-6">
          <div className="flex gap-4 items-start">
            <div className="w-11 h-11 rounded-xl bg-emerald-500/10 text-emerald-400 flex items-center justify-center font-bold text-base shrink-0">BI</div>
            <div>
              <span className="block font-bold text-base text-slate-200">Bilal Imran</span>
              <span className="text-xs text-slate-400 block mt-1">DHA Phase 6 ➔ Shahrah-e-Faisal</span>
              <span className="text-[11px] font-semibold text-emerald-400 bg-emerald-500/5 border border-emerald-500/10 rounded px-2 py-0.5 mt-2 inline-block">HBL (Habib Bank Ltd) Verified</span>
            </div>
          </div>
          <div className="flex items-center gap-6">
            <div className="text-right">
              <span className="block text-lg font-extrabold text-white">Rs. 210</span>
              <span className="text-xs text-slate-500 block">Seat price one-way</span>
            </div>
            <button className="bg-gradient-to-r from-emerald-500 to-teal-400 hover:from-emerald-400 hover:to-teal-300 text-slate-950 px-5 py-2.5 rounded-xl text-xs font-bold transition-all">
              Request Seat
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
