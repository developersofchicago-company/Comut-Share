"use client";

import React, { useState } from "react";

export default function WalletPage() {
  const [amount, setAmount] = useState(1000);

  return (
    <div className="space-y-8">
      {/* Wallet Balance Card */}
      <div className="bg-gradient-to-br from-slate-900 to-slate-950 border border-slate-800 p-8 rounded-2xl shadow-xl max-w-xl">
        <span className="text-xs uppercase font-bold tracking-widest text-slate-500 block mb-2">Available Balance</span>
        <span className="text-4xl font-extrabold text-white">Rs. 4,840</span>
        <div className="mt-8 flex gap-4">
          <button className="flex-1 bg-gradient-to-r from-emerald-500 to-teal-400 hover:from-emerald-400 hover:to-teal-300 text-slate-950 font-bold py-3.5 rounded-xl text-sm transition-all shadow-lg shadow-emerald-500/10">
            Deposit Funds
          </button>
          <button className="flex-1 bg-slate-900 hover:bg-slate-850 border border-slate-800 text-slate-200 font-bold py-3.5 rounded-xl text-sm transition-all">
            Withdraw Earnings
          </button>
        </div>
      </div>

      {/* Transaction History */}
      <div className="space-y-4 max-w-xl">
        <h4 className="font-bold text-sm text-slate-400 uppercase tracking-wider">Transaction History</h4>
        <div className="bg-slate-900/40 rounded-2xl border border-slate-900 divide-y divide-slate-800/60 overflow-hidden">
          <div className="p-4 flex items-center justify-between">
            <div>
              <span className="block font-bold text-sm text-slate-200">Ride Payment (Escrow)</span>
              <span className="text-[10px] text-slate-500 block">27 May 2026</span>
            </div>
            <span className="font-bold text-red-400 text-sm">- Rs. 210</span>
          </div>
          <div className="p-4 flex items-center justify-between">
            <div>
              <span className="block font-bold text-sm text-slate-200">Wallet Top-up (EasyPaisa)</span>
              <span className="text-[10px] text-slate-500 block">25 May 2026</span>
            </div>
            <span className="font-bold text-emerald-400 text-sm">+ Rs. 5,000</span>
          </div>
        </div>
      </div>
    </div>
  );
}
