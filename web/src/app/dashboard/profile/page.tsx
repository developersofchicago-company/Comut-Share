"use client";

import React, { useState } from "react";

export default function ProfilePage() {
  const [name, setName] = useState("Usman Imran");
  const [home, setHome] = useState("DHA Phase 6");
  const [office, setOffice] = useState("Shahrah-e-Faisal");
  const [hours, setHours] = useState("09:00 AM - 05:00 PM");

  return (
    <div className="space-y-8">
      <div className="bg-slate-900/40 border border-slate-900 rounded-2xl p-8 max-w-xl">
        <h3 className="font-bold text-lg text-white mb-6">Commuter Profile Preferences</h3>
        <form className="space-y-6" onSubmit={(e) => e.preventDefault()}>
          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-500 uppercase">Full Name</label>
            <input
              type="text"
              value={name}
              onChange={(e) => setName(e.target.value)}
              className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
            />
          </div>

          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-500 uppercase">Home Area shortcut</label>
            <input
              type="text"
              value={home}
              onChange={(e) => setHome(e.target.value)}
              className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
            />
          </div>

          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-500 uppercase">Office Area shortcut</label>
            <input
              type="text"
              value={office}
              onChange={(e) => setOffice(e.target.value)}
              className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
            />
          </div>

          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-500 uppercase">Usual Office working hours</label>
            <input
              type="text"
              value={hours}
              onChange={(e) => setHours(e.target.value)}
              className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
            />
          </div>

          <button
            type="submit"
            className="w-full py-4 rounded-xl bg-gradient-to-r from-emerald-500 to-teal-400 hover:from-emerald-400 hover:to-teal-300 text-slate-950 font-bold transition-all text-sm shadow-lg shadow-emerald-500/15"
          >
            Update Profile Preferences
          </button>
        </form>
      </div>
    </div>
  );
}
