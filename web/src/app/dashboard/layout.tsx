"use client";

import React, { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const [sidebarOpen, setSidebarOpen] = useState(true);

  const navItems = [
    { name: "Overview", href: "/dashboard", icon: "📊" },
    { name: "Find a Ride", href: "/dashboard/find-ride", icon: "🔍" },
    { name: "Offer a Ride", href: "/dashboard/post-ride", icon: "🚗" },
    { name: "Wallet", href: "/dashboard/wallet", icon: "💼" },
    { name: "Profile", href: "/dashboard/profile", icon: "👤" },
  ];

  return (
    <div className="flex h-screen bg-slate-950 text-slate-100 font-sans overflow-hidden">
      {/* Sidebar */}
      <aside
        className={`${
          sidebarOpen ? "w-64" : "w-20"
        } bg-slate-900 border-r border-slate-800 transition-all duration-300 flex flex-col shrink-0`}
      >
        {/* Brand */}
        <div className="p-6 flex items-center gap-3 border-b border-slate-800/60">
          <div className="w-9 h-9 rounded-xl bg-gradient-to-tr from-emerald-500 to-teal-400 flex items-center justify-center shadow-lg shadow-emerald-500/20 shrink-0">
            <svg className="w-5.5 h-5.5 text-slate-950" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
            </svg>
          </div>
          {sidebarOpen && (
            <div>
              <span className="font-bold text-base bg-gradient-to-r from-emerald-400 to-teal-200 bg-clip-text text-transparent">ComutShare</span>
              <span className="text-[10px] block text-slate-500 font-semibold uppercase tracking-wider">Karachi Portal</span>
            </div>
          )}
        </div>

        {/* Nav Links */}
        <nav className="flex-1 px-4 py-6 space-y-2 overflow-y-auto">
          {navItems.map((item) => {
            const isActive = pathname === item.href;
            return (
              <Link
                key={item.href}
                href={item.href}
                className={`flex items-center gap-4 px-4 py-3 rounded-xl text-sm font-semibold transition-all duration-200 ${
                  isActive
                    ? "bg-gradient-to-r from-emerald-500/15 to-teal-500/5 text-emerald-400 border border-emerald-500/20"
                    : "text-slate-400 hover:bg-slate-800/40 hover:text-slate-200 border border-transparent"
                }`}
              >
                <span className="text-lg">{item.icon}</span>
                {sidebarOpen && <span>{item.name}</span>}
              </Link>
            );
          })}
        </nav>

        {/* Footer info or toggle */}
        <div className="p-4 border-t border-slate-800/60 flex items-center justify-between">
          {sidebarOpen && (
            <div className="flex items-center gap-3">
              <div className="w-8 h-8 rounded-full bg-emerald-500/10 text-emerald-400 flex items-center justify-center font-bold text-xs">UI</div>
              <div>
                <span className="block text-xs font-bold text-slate-200">Usman Imran</span>
                <span className="text-[9px] text-slate-500 block">name@company.com</span>
              </div>
            </div>
          )}
          <button
            onClick={() => setSidebarOpen(!sidebarOpen)}
            className="p-1.5 rounded-lg hover:bg-slate-800 text-slate-500 hover:text-slate-300"
          >
            {sidebarOpen ? "◀" : "▶"}
          </button>
        </div>
      </aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        {/* Header */}
        <header className="h-16 border-b border-slate-900 bg-slate-950/80 backdrop-blur flex items-center justify-between px-8 z-10 shrink-0">
          <div className="flex items-center gap-4">
            <h1 className="font-bold text-lg text-white">
              {navItems.find((item) => item.href === pathname)?.name || "Dashboard"}
            </h1>
            <span className="text-xs font-semibold px-2.5 py-0.5 rounded-full bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
              Verified Domain Whitelist
            </span>
          </div>
          <div className="flex items-center gap-6 text-sm">
            <div className="flex items-center gap-2">
              <span className="text-slate-500 text-xs font-semibold">WALLET:</span>
              <span className="font-extrabold text-emerald-400">Rs. 4,840</span>
            </div>
            <Link
              href="/"
              className="bg-slate-900 hover:bg-slate-800 border border-slate-800 text-slate-300 px-4 py-2 rounded-xl text-xs font-bold transition-all"
            >
              Sign Out
            </Link>
          </div>
        </header>

        {/* Scrollable Viewport */}
        <main className="flex-1 overflow-y-auto p-8 bg-slate-950/30">
          <div className="max-w-6xl mx-auto space-y-8">
            {children}
          </div>
        </main>
      </div>
    </div>
  );
}
