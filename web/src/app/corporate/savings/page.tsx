"use client";

export default function SavingsReportPage() {
  // INTEGRATION POINT: Real values would come from aggregations of:
  //   - bookings × ride.price_per_seat × days
  //   - distance × OGRA rate / efficiency (solo-drive baseline)
  //   - distance × 0.12 kg CO2 per km saved
  const monthlyData = [
    { month: "Jan 2026", riders: 18, rides: 142, fuelSaved: 85200, co2Saved: 397 },
    { month: "Feb 2026", riders: 24, rides: 198, fuelSaved: 118800, co2Saved: 554 },
    { month: "Mar 2026", riders: 31, rides: 245, fuelSaved: 147000, co2Saved: 686 },
    { month: "Apr 2026", riders: 38, rides: 287, fuelSaved: 172200, co2Saved: 804 },
    { month: "May 2026", riders: 47, rides: 312, fuelSaved: 187200, co2Saved: 874 },
  ];

  const totalFuel = monthlyData.reduce((s, m) => s + m.fuelSaved, 0);
  const totalCo2 = monthlyData.reduce((s, m) => s + m.co2Saved, 0);
  const totalRides = monthlyData.reduce((s, m) => s + m.rides, 0);

  return (
    <div className="space-y-8">
      <div className="grid sm:grid-cols-3 gap-4">
        <div className="rounded-2xl border border-[#1E1E1E] bg-[#0F0F0F] p-6">
          <span className="text-xs uppercase font-bold tracking-wider text-slate-500">YTD Fuel Saved</span>
          <div className="text-3xl font-extrabold text-[#A6CE39] mt-2">Rs. {totalFuel.toLocaleString()}</div>
          <p className="text-xs text-slate-500 mt-2">~Rs. {Math.round(totalFuel / totalRides).toLocaleString()} per ride avg</p>
        </div>
        <div className="rounded-2xl border border-[#1E1E1E] bg-[#0F0F0F] p-6">
          <span className="text-xs uppercase font-bold tracking-wider text-slate-500">YTD CO₂ Avoided</span>
          <div className="text-3xl font-extrabold text-[#A6CE39] mt-2">{totalCo2.toLocaleString()} kg</div>
          <p className="text-xs text-slate-500 mt-2">≈ {Math.round(totalCo2 / 1000)} trees worth</p>
        </div>
        <div className="rounded-2xl border border-[#1E1E1E] bg-[#0F0F0F] p-6">
          <span className="text-xs uppercase font-bold tracking-wider text-slate-500">Total Shared Rides</span>
          <div className="text-3xl font-extrabold text-white mt-2">{totalRides.toLocaleString()}</div>
          <p className="text-xs text-slate-500 mt-2">Cars off the road during peak hours</p>
        </div>
      </div>

      <div className="rounded-2xl border border-[#1E1E1E] bg-[#0F0F0F] overflow-hidden">
        <div className="p-6 border-b border-[#1E1E1E]">
          <h3 className="font-bold text-white">Monthly Breakdown</h3>
        </div>
        <table className="w-full text-sm">
          <thead className="bg-[#1A1A1A] text-xs uppercase tracking-wider text-slate-500">
            <tr>
              <th className="text-left px-6 py-3 font-bold">Month</th>
              <th className="text-right px-6 py-3 font-bold">Active Riders</th>
              <th className="text-right px-6 py-3 font-bold">Total Rides</th>
              <th className="text-right px-6 py-3 font-bold">Fuel Saved</th>
              <th className="text-right px-6 py-3 font-bold">CO₂ kg</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[#1E1E1E]">
            {monthlyData.map((m) => (
              <tr key={m.month} className="hover:bg-[#1A1A1A]/40">
                <td className="px-6 py-3 font-semibold text-white">{m.month}</td>
                <td className="px-6 py-3 text-right text-slate-300">{m.riders}</td>
                <td className="px-6 py-3 text-right text-slate-300">{m.rides}</td>
                <td className="px-6 py-3 text-right text-[#A6CE39] font-bold">Rs. {m.fuelSaved.toLocaleString()}</td>
                <td className="px-6 py-3 text-right text-slate-300">{m.co2Saved}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="rounded-2xl border border-[#A6CE39]/20 bg-[#A6CE39]/5 p-6">
        <h4 className="font-bold text-white mb-2">Export ESG report</h4>
        <p className="text-sm text-slate-400 mb-4">Download a branded PDF for your annual sustainability report.</p>
        <button className="bg-[#A6CE39] hover:bg-[#92b532] text-black font-extrabold px-5 py-2.5 rounded-xl text-sm transition-all">
          Download PDF Report
        </button>
        <span className="ml-3 text-xs text-slate-500">PDF generator pending integration</span>
      </div>
    </div>
  );
}
