"use client";

import { useState } from "react";

export default function SubsidyControlsPage() {
  const [subsidyEnabled, setSubsidyEnabled] = useState(true);
  const [perRideSubsidy, setPerRideSubsidy] = useState(50);
  const [monthlyCap, setMonthlyCap] = useState(2000);
  const [eligibility, setEligibility] = useState<"all" | "drivers" | "riders">("riders");

  return (
    <div className="space-y-6">
      <div className="rounded-2xl border border-[#1E1E1E] bg-[#0F0F0F] p-6 space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="font-bold text-white text-lg">Company Subsidy Program</h3>
            <p className="text-sm text-slate-400 mt-1">Reimburse employees automatically from your monthly invoice.</p>
          </div>
          <label className="relative inline-flex items-center cursor-pointer">
            <input
              type="checkbox"
              className="sr-only peer"
              checked={subsidyEnabled}
              onChange={(e) => setSubsidyEnabled(e.target.checked)}
            />
            <div className="w-14 h-7 bg-[#1A1A1A] rounded-full peer peer-checked:bg-[#A6CE39] transition-colors after:content-[''] after:absolute after:top-1 after:left-1 after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:after:translate-x-7" />
          </label>
        </div>

        <div className={`space-y-6 ${!subsidyEnabled ? "opacity-40 pointer-events-none" : ""}`}>
          <div>
            <label className="block text-sm font-bold text-slate-300 mb-2">Per-Ride Subsidy</label>
            <div className="flex items-center gap-4">
              <input
                type="range"
                min="0"
                max="200"
                step="10"
                value={perRideSubsidy}
                onChange={(e) => setPerRideSubsidy(Number(e.target.value))}
                className="flex-1 accent-[#A6CE39]"
              />
              <div className="w-32 text-right">
                <span className="text-2xl font-extrabold text-[#A6CE39]">Rs. {perRideSubsidy}</span>
                <span className="block text-xs text-slate-500">per ride</span>
              </div>
            </div>
          </div>

          <div>
            <label className="block text-sm font-bold text-slate-300 mb-2">Monthly Cap per Employee</label>
            <div className="flex items-center gap-4">
              <input
                type="range"
                min="0"
                max="10000"
                step="500"
                value={monthlyCap}
                onChange={(e) => setMonthlyCap(Number(e.target.value))}
                className="flex-1 accent-[#A6CE39]"
              />
              <div className="w-32 text-right">
                <span className="text-2xl font-extrabold text-white">Rs. {monthlyCap.toLocaleString()}</span>
                <span className="block text-xs text-slate-500">cap</span>
              </div>
            </div>
          </div>

          <div>
            <label className="block text-sm font-bold text-slate-300 mb-2">Eligibility</label>
            <div className="flex gap-3">
              {(["all", "riders", "drivers"] as const).map((opt) => (
                <button
                  key={opt}
                  onClick={() => setEligibility(opt)}
                  className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                    eligibility === opt
                      ? "bg-[#A6CE39] text-black"
                      : "bg-[#1A1A1A] text-slate-400 hover:bg-[#222222]"
                  }`}
                >
                  {opt[0].toUpperCase() + opt.slice(1)}
                </button>
              ))}
            </div>
          </div>
        </div>
      </div>

      <div className="rounded-2xl border border-[#1E1E1E] bg-[#0F0F0F] p-6">
        <h4 className="font-bold text-white mb-3">Estimated Monthly Impact</h4>
        <div className="grid sm:grid-cols-3 gap-4 text-sm">
          <div>
            <span className="text-xs uppercase font-bold tracking-wider text-slate-500">Subsidized rides / mo</span>
            <div className="text-xl font-extrabold text-white mt-1">≈ 312</div>
          </div>
          <div>
            <span className="text-xs uppercase font-bold tracking-wider text-slate-500">Total cost / mo</span>
            <div className="text-xl font-extrabold text-[#A6CE39] mt-1">Rs. {(perRideSubsidy * 312).toLocaleString()}</div>
          </div>
          <div>
            <span className="text-xs uppercase font-bold tracking-wider text-slate-500">vs. parking lease</span>
            <div className="text-xl font-extrabold text-white mt-1">−Rs. 80,000 saved</div>
          </div>
        </div>
      </div>

      <button className="w-full bg-[#A6CE39] hover:bg-[#92b532] text-black font-extrabold py-4 rounded-xl transition-all">
        Save Subsidy Policy
      </button>
    </div>
  );
}
