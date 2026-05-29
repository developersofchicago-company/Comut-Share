"use client";

import { useEffect, useState } from "react";

export default function MobileAppBanner() {
  const [timeLeft, setTimeLeft] = useState({ days: 0, hours: 0, minutes: 0, seconds: 0 });

  useEffect(() => {
    const target = new Date("2026-08-01T00:00:00Z").getTime();
    const tick = () => {
      const diff = target - Date.now();
      if (diff <= 0) return;
      setTimeLeft({
        days: Math.floor(diff / 86400000),
        hours: Math.floor((diff % 86400000) / 3600000),
        minutes: Math.floor((diff % 3600000) / 60000),
        seconds: Math.floor((diff % 60000) / 1000),
      });
    };
    tick();
    const id = setInterval(tick, 1000);
    return () => clearInterval(id);
  }, []);

  const perks = [
    { icon: "🚗", title: "Real-Time Ride Matching", desc: "Geo matching within 2 km of your pickup point" },
    { icon: "🔐", title: "Corporate Whitelist Only", desc: "Verified org email + CNIC — zero strangers" },
    { icon: "💳", title: "Escrow Wallet", desc: "Funds held safely until ride is completed" },
    { icon: "⭐", title: "Reputation System", desc: "Every driver & rider rated after each trip" },
  ];

  return (
    <section id="coming-soon" className="py-24 px-6 bg-gradient-to-br from-[#0A0A0A] via-[#0F0F0F] to-[#0A0A0A] border-y border-[#1E1E1E]">
      <div className="max-w-7xl mx-auto">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          <div className="space-y-8">
            <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-[#A6CE39]/10 border border-[#A6CE39]/20 text-[#A6CE39] text-[11px] font-bold tracking-wide">
              <span className="w-1.5 h-1.5 rounded-full bg-[#A6CE39] animate-pulse" />
              Mobile App — Launching Summer 2026
            </div>
            <h2 className="text-3xl sm:text-4xl font-extrabold text-white leading-tight">
              ComutShare <span className="text-[#A6CE39]">Mobile</span> is almost here
            </h2>
            <p className="text-slate-400 text-base leading-relaxed">
              iOS & Android apps with live ride matching, in-app chat, escrow payments, and corporate SSO. Built for Karachi&apos;s corporate commuters.
            </p>
            <div className="flex gap-4">
              {[
                { label: "Days", value: timeLeft.days },
                { label: "Hours", value: timeLeft.hours },
                { label: "Mins", value: timeLeft.minutes },
                { label: "Secs", value: timeLeft.seconds },
              ].map(({ label, value }) => (
                <div key={label} className="flex-1 bg-[#121212] border border-[#222222] rounded-xl p-3 text-center">
                  <span className="block text-2xl font-extrabold text-[#A6CE39]">{String(value).padStart(2, "0")}</span>
                  <span className="text-[10px] text-slate-500 uppercase font-bold tracking-wider">{label}</span>
                </div>
              ))}
            </div>
            <p className="text-xs text-slate-500">Get notified at launch → <a href="#waitlist" className="text-[#A6CE39] underline underline-offset-2">Join the waitlist</a></p>
          </div>
          <div className="grid grid-cols-2 gap-4">
            {perks.map((p) => (
              <div key={p.title} className="bg-[#121212] border border-[#1E1E1E] rounded-2xl p-5 space-y-3 hover:border-[#A6CE39]/20 transition-all">
                <span className="text-3xl">{p.icon}</span>
                <div>
                  <span className="block font-bold text-white text-sm">{p.title}</span>
                  <span className="text-xs text-slate-500 leading-relaxed">{p.desc}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
