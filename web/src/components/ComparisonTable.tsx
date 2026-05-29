export default function ComparisonTable() {
  const features = [
    { feature: "Verified corporate identity", comutshare: true, careem: false, facebook: false },
    { feature: "CNIC background check", comutshare: true, careem: false, facebook: false },
    { feature: "Live OGRA-anchored pricing", comutshare: true, careem: false, facebook: false },
    { feature: "Escrow payment protection", comutshare: true, careem: true, facebook: false },
    { feature: "In-app ride chat", comutshare: true, careem: true, facebook: false },
    { feature: "Reputation & rating system", comutshare: true, careem: true, facebook: false },
    { feature: "Corporate HR dashboard", comutshare: true, careem: false, facebook: false },
    { feature: "Subsidy & expense management", comutshare: true, careem: false, facebook: false },
    { feature: "Cost (20 km one-way)", comutshare: "Rs. ~283", careem: "Rs. ~900", facebook: "Varies" },
  ];

  const Check = () => (
    <svg className="w-5 h-5 text-[#A6CE39] mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M5 13l4 4L19 7" />
    </svg>
  );
  const Cross = () => (
    <svg className="w-5 h-5 text-slate-600 mx-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
      <path strokeLinecap="round" strokeLinejoin="round" d="M6 18L18 6M6 6l12 12" />
    </svg>
  );

  return (
    <section className="py-24 px-6">
      <div className="max-w-5xl mx-auto">
        <div className="text-center max-w-2xl mx-auto mb-16 space-y-4">
          <span className="text-xs uppercase font-bold tracking-widest text-[#A6CE39]">Comparison</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Why not just use Careem?</h2>
          <p className="text-slate-400">Ride-hailing solves convenience, not cost or trust. ComutShare is built for the daily commuter, not the occasional ride.</p>
        </div>
        <div className="rounded-2xl border border-[#1E1E1E] overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-[#0F0F0F] border-b border-[#1E1E1E]">
                <th className="text-left px-6 py-4 text-slate-500 font-bold text-xs uppercase tracking-wider w-1/2">Feature</th>
                <th className="px-6 py-4 text-center">
                  <span className="text-[#A6CE39] font-extrabold text-sm">ComutShare</span>
                </th>
                <th className="px-6 py-4 text-center text-slate-400 font-bold text-sm">Careem</th>
                <th className="px-6 py-4 text-center text-slate-400 font-bold text-sm">FB Groups</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-[#1A1A1A]">
              {features.map((row) => (
                <tr key={row.feature} className="hover:bg-[#0F0F0F]/60 transition-colors">
                  <td className="px-6 py-3.5 text-slate-300 font-medium">{row.feature}</td>
                  <td className="px-6 py-3.5 text-center">
                    {typeof row.comutshare === "boolean" ? (row.comutshare ? <Check /> : <Cross />) : (
                      <span className="font-extrabold text-[#A6CE39]">{row.comutshare}</span>
                    )}
                  </td>
                  <td className="px-6 py-3.5 text-center">
                    {typeof row.careem === "boolean" ? (row.careem ? <Check /> : <Cross />) : (
                      <span className="font-bold text-slate-400">{row.careem}</span>
                    )}
                  </td>
                  <td className="px-6 py-3.5 text-center">
                    {typeof row.facebook === "boolean" ? (row.facebook ? <Check /> : <Cross />) : (
                      <span className="font-bold text-slate-400">{row.facebook}</span>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </section>
  );
}
