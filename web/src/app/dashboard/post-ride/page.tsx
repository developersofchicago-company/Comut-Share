"use client";

import React, { useState } from "react";

export default function PostRidePage() {
  const [from, setFrom] = useState("DHA Phase 6");
  const [to, setTo] = useState("Shahrah-e-Faisal");
  const [seats, setSeats] = useState(3);
  const [price, setPrice] = useState(210);

  return (
    <div className="space-y-8">
      <div className="bg-slate-900/40 border border-slate-900 rounded-2xl p-8 max-w-2xl">
        <h3 className="font-bold text-lg text-white mb-6">Publish a Carpool Ride Offer</h3>
        <form className="space-y-6" onSubmit={(e) => e.preventDefault()}>
          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-500 uppercase">Commute From</label>
            <input
              type="text"
              value={from}
              onChange={(e) => setFrom(e.target.value)}
              className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
            />
          </div>

          <div className="space-y-2">
            <label className="block text-xs font-semibold text-slate-500 uppercase">Commute To</label>
            <input
              type="text"
              value={to}
              onChange={(e) => setTo(e.target.value)}
              className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
            />
          </div>

          <div className="grid grid-cols-2 gap-6">
            <div className="space-y-2">
              <label className="block text-xs font-semibold text-slate-500 uppercase">Available Passenger Seats</label>
              <select
                value={seats}
                onChange={(e) => setSeats(Number(e.target.value))}
                className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
              >
                <option value={1}>1 seat</option>
                <option value={2}>2 seats</option>
                <option value={3}>3 seats (Default)</option>
                <option value={4}>4 seats</option>
              </select>
            </div>

            <div className="space-y-2">
              <label className="block text-xs font-semibold text-slate-500 uppercase">Seat Price (Rs.)</label>
              <input
                type="number"
                value={price}
                onChange={(e) => setPrice(Number(e.target.value))}
                className="w-full bg-slate-950/80 border border-slate-800 rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-emerald-500 text-sm"
              />
            </div>
          </div>

          <div className="p-4 rounded-xl bg-slate-950/60 border border-slate-900 text-xs text-slate-500 leading-relaxed">
            Suggested price is calculated dynamically using live OGRA fuel rate and Rs. 8/km wear-and-tear margin.
          </div>

          <button
            type="submit"
            className="w-full py-4 rounded-xl bg-gradient-to-r from-emerald-500 to-teal-400 hover:from-emerald-400 hover:to-teal-300 text-slate-950 font-bold transition-all text-sm shadow-lg shadow-emerald-500/15"
          >
            Publish Ride Offer
          </button>
        </form>
      </div>
    </div>
  );
}
