"use client";

import React from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";

export default function CorporateLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();

  const navItems = [
    { name: "Overview", href: "/corporate", icon: "📊" },
    { name: "Employees", href: "/corporate/employees", icon: "👥" },
    { name: "Rides & Trips", href: "/corporate/rides", icon: "🚗" },
    { name: "Savings Report", href: "/corporate/savings", icon: "💰" },
    { name: "Subsidy Controls", href: "/corporate/subsidy", icon: "🎛️" },
    { name: "Billing", href: "/corporate/billing", icon: "💳" },
  ];

  return (
    <div className="flex h-screen bg-[#0A0A0A] text-slate-100 font-sans overflow-hidden">
      <aside className="w-64 bg-[#0F0F0F] border-r border-[#1E1E1E] flex flex-col shrink-0">
        <div className="p-6 flex items-center gap-3 border-b border-[#1E1E1E]">
          <div className="w-10 h-10 rounded-xl bg-[#A6CE39] flex items-center justify-center shadow-lg shadow-[#A6CE39]/15">
            <svg className="w-6 h-6 text-black" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M21 13.255A23.931 23.931 0 0112 15c-3.183 0-6.22-.62-9-1.745M16 6V4a2 2 0 00-2-2h-4a2 2 0 00-2 2v2m4 6h.01M5 20h14a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
          </div>
          <div>
            <span className="font-bold text-base text-white">Corporate Portal</span>
            <span className="text-[10px] block text-[#A6CE39] font-bold tracking-wider uppercase">HR Dashboard</span>
          </div>
        </div>

        <nav className="flex-1 px-4 py-6 space-y-1 overflow-y-auto">
          {navItems.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-semibold transition-all ${
                  isActive
                    ? "bg-[#A6CE39]/10 text-[#A6CE39] border border-[#A6CE39]/20"
                    : "text-slate-400 hover:bg-[#1A1A1A] hover:text-slate-200 border border-transparent"
                }`}
              >
                <span>{item.icon}</span>
                <span>{item.name}</span>
              </Link>
            );
          })}
        </nav>

        <div className="p-4 border-t border-[#1E1E1E]">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 rounded-full bg-[#A6CE39]/10 text-[#A6CE39] flex items-center justify-center font-bold text-xs">HBL</div>
            <div className="flex-1 min-w-0">
              <span className="block text-xs font-bold text-slate-200 truncate">Habib Bank Ltd</span>
              <span className="text-[10px] text-slate-500 block">hr@hbl.com</span>
            </div>
          </div>
        </div>
      </aside>

      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        <header className="h-16 border-b border-[#1E1E1E] bg-[#0A0A0A]/90 backdrop-blur flex items-center justify-between px-8 shrink-0">
          <div className="flex items-center gap-4">
            <h1 className="font-bold text-lg text-white">
              {navItems.find((i) => i.href === pathname)?.name || "Dashboard"}
            </h1>
            <span className="text-xs font-semibold px-2.5 py-0.5 rounded-full bg-[#A6CE39]/10 text-[#A6CE39] border border-[#A6CE39]/20">
              Pilot Plan · May 2026
            </span>
          </div>
          <div className="flex items-center gap-4 text-sm">
            <Link href="/" className="bg-[#1A1A1A] hover:bg-[#222222] border border-[#222222] text-slate-300 px-4 py-2 rounded-xl text-xs font-bold transition-all">
              Sign Out
            </Link>
          </div>
        </header>

        <main className="flex-1 overflow-y-auto p-8">
          <div className="max-w-6xl mx-auto space-y-8">{children}</div>
        </main>
      </div>
    </div>
  );
}
