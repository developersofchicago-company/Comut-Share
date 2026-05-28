"use client";

import { useState, useEffect } from "react";

export default function MobileAppBanner() {
  // Countdown to July 15, 2026 launch
  const launchDate = new Date("2026-07-15T00:00:00").getTime();
  const [timeLeft, setTimeLeft] = useState({ days: 0, hours: 0, mins: 0, secs: 0 });

  useEffect(() => {
    const timer = setInterval(() => {
      const now = new Date().getTime();
      const diff = launchDate - now;
      if (diff <= 0) { clearInterval(timer); return; }
      setTimeLeft({
        days: Math.floor(diff / (1000 * 60 * 60 * 24)),
        hours: Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)),
        mins: Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60)),
        secs: Math.floor((diff % (1000 * 60)) / 1000),
      });
    }, 1000);
    return () => clearInterval(timer);
  }, [launchDate]);

  const perks = [
    { icon: "🎁", title: "Rs. 500 Free Credit", desc: "Pre-loaded balance for your first rides" },
    { icon: "🥇", title: "Founding Commuter Badge", desc: "Permanent OG profile badge" },
    { icon: "🔓", title: "Skip Verification Queue", desc: "Priority instant CNIC verification" },
  ];

  return (
    <section id="coming-soon" className="py-20 px-6 bg-gradient-to-r from-[#121212] via-[#1A1A1A] to-[#121212] border-y border-[#1E1E1E] relative overflow-hidden">
      <div className="absolute top-1/2 left-1/4 w-[400px] h-[400px] bg-[#A6CE39]/5 rounded-full blur-3xl -translate-y-1/2 -z-10" />
      <div className="max-w-7xl mx-auto grid md:grid-cols-12 gap-12 items-center">
        {/* Left: Content */}
        <div className="md:col-span-7 space-y-8">
          <span className="text-xs font-extrabold text-[#A6CE39] uppercase tracking-widest bg-[#A6CE39]/10 border border-[#A6CE39]/20 px-3 py-1 rounded-full inline-block">
            📱 Mobile App Coming Soon
          </span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white tracking-tight">
            On-The-Road Commuting, <br />
            <span className="text-[#A6CE39]">Direct From Your Phone</span>
          </h2>

          {/* Countdown Timer */}
          <div className="flex gap-3">
            {[
              { val: timeLeft.days, label: "Days" },
              { val: timeLeft.hours, label: "Hours" },
              { val: timeLeft.mins, label: "Mins" },
              { val: timeLeft.secs, label: "Secs" },
            ].map((t, i) => (
              <div key={i} className="bg-[#0A0A0A] border border-[#1E1E1E] rounded-xl px-4 py-3 text-center min-w-[64px]">
                <span className="text-2xl font-extrabold text-white block">{String(t.val).padStart(2, "0")}</span>
                <span className="text-[9px] text-slate-500 font-bold uppercase tracking-wider">{t.label}</span>
              </div>
            ))}
          </div>

          <p className="text-slate-400 text-sm leading-relaxed max-w-xl">
            Live GPS Route Matching, 4-Digit Boarding Escrow Verification, and Instant In-App Coord-Chat — so your phone numbers are never shared. Currently in closed beta testing.
          </p>

          {/* VIP Early Access Perks */}
          <div className="space-y-3">
            <span className="text-xs font-bold text-slate-400 uppercase tracking-wider">Early Access VIP Perks:</span>
            <div className="grid sm:grid-cols-3 gap-3">
              {perks.map((perk, i) => (
                <div key={i} className="bg-[#0A0A0A] border border-[#1E1E1E] rounded-xl p-4 space-y-1">
                  <span className="text-lg">{perk.icon}</span>
                  <span className="block text-xs font-bold text-white">{perk.title}</span>
                  <span className="block text-[10px] text-slate-500">{perk.desc}</span>
                </div>
              ))}
            </div>
          </div>

          {/* App Store Placeholder Badges */}
          <div className="flex flex-wrap gap-3 items-center">
            <div className="flex items-center gap-2 bg-[#1A1A1A] border border-[#2A2A2A] px-5 py-3 rounded-xl">
              <span className="text-lg">🤖</span>
              <div>
                <span className="text-[9px] text-slate-500 block font-semibold uppercase">Google Play</span>
                <span className="text-xs text-slate-300 font-bold">Coming Soon</span>
              </div>
            </div>
            <div className="flex items-center gap-2 bg-[#1A1A1A] border border-[#2A2A2A] px-5 py-3 rounded-xl">
              <span className="text-lg">🍏</span>
              <div>
                <span className="text-[9px] text-slate-500 block font-semibold uppercase">App Store</span>
                <span className="text-xs text-slate-300 font-bold">Coming Soon</span>
              </div>
            </div>
            <a href="#waitlist" className="text-xs font-bold text-[#A6CE39] uppercase tracking-wider hover:underline flex items-center gap-1.5 ml-2">
              Join waitlist for launch access ➔
            </a>
          </div>
        </div>

        {/* Right: Phone Mockup */}
        <div className="md:col-span-5 flex justify-center">
          <div className="w-[260px] h-[500px] rounded-[36px] border-4 border-[#2A2A2A] bg-[#0A0A0A] p-3 shadow-2xl relative overflow-hidden">
            <div className="absolute top-0 left-1/2 -translate-x-1/2 w-28 h-4 bg-black rounded-b-xl z-20 flex items-center justify-center">
              <div className="w-10 h-1 bg-[#1A1A1A] rounded-full" />
            </div>
            <div className="h-full w-full rounded-[28px] bg-[#121212] p-4 flex flex-col justify-between border border-[#1E1E1E]">
              <div className="space-y-4 pt-3">
                <div className="flex justify-between items-center">
                  <span className="text-[10px] font-bold text-[#A6CE39]">ComutShare Live</span>
                  <span className="text-[9px] text-slate-500 font-semibold">Active Match</span>
                </div>
                <div className="p-3 bg-[#0A0A0A] rounded-xl border border-[#1E1E1E] space-y-2">
                  <div className="flex items-center gap-2">
                    <span className="w-2 h-2 rounded-full bg-[#A6CE39]" />
                    <span className="text-[10px] text-slate-300 font-bold">DHA Phase 6</span>
                  </div>
                  <div className="w-0.5 h-3 bg-slate-800 ml-1" />
                  <div className="flex items-center gap-2">
                    <span className="w-2 h-2 rounded-full bg-blue-400" />
                    <span className="text-[10px] text-slate-300 font-bold">Shahrah-e-Faisal</span>
                  </div>
                </div>
              </div>
              <div className="flex-1 my-3 bg-[#0A0A0A] rounded-2xl border border-[#1E1E1E] flex flex-col items-center justify-center relative overflow-hidden">
                <div className="absolute inset-0 opacity-15 bg-[radial-gradient(#A6CE39_1px,transparent_1px)] [background-size:16px_16px]" />
                <div className="w-24 h-24 rounded-full bg-[#A6CE39]/5 border border-[#A6CE39]/10 animate-ping absolute" />
                <div className="w-12 h-12 rounded-full bg-[#A6CE39]/10 border border-[#A6CE39]/30 flex items-center justify-center z-10">
                  <svg className="w-6 h-6 text-[#A6CE39]" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                    <path strokeLinecap="round" strokeLinejoin="round" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                    <path strokeLinecap="round" strokeLinejoin="round" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                </div>
                <span className="text-[9px] text-[#A6CE39] font-bold mt-2 z-10 uppercase tracking-widest">Searching...</span>
              </div>
              <div className="space-y-2">
                <div className="flex justify-between items-center text-[10px]">
                  <span className="text-slate-500">Split Fuel saving:</span>
                  <span className="text-white font-bold">Rs. 220 net</span>
                </div>
                <div className="w-full bg-[#A6CE39] text-black text-center py-2 rounded-xl text-[10px] font-extrabold uppercase tracking-wider">
                  Coming Soon
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
