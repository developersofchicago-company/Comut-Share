export default function ComparisonTable() {
  const rows = [
    { feature: "Monthly Cost (20km)", solo: "Rs. 60,000+", careem: "Rs. 39,600", comut: "Rs. 24,860", highlight: true },
    { feature: "Driver Verification", solo: "❌ None", careem: "Basic ID", comut: "✅ CNIC + Corp Email", highlight: false },
    { feature: "Price Transparency", solo: "Fixed fuel cost", careem: "Surge pricing", comut: "✅ OGRA formula", highlight: false },
    { feature: "Recurring Schedule", solo: "N/A", careem: "Book daily", comut: "✅ Auto-match", highlight: false },
    { feature: "Women-Only Mode", solo: "❌", careem: "❌", comut: "✅ Built-in", highlight: false },
    { feature: "CO2 Reduction", solo: "0%", careem: "0%", comut: "✅ Up to 75%", highlight: false },
    { feature: "Cost Trend", solo: "📈 Rising", careem: "📈 Rising", comut: "📉 Splits with riders", highlight: false },
  ];

  return (
    <section className="py-24 px-6 border-t border-[#1E1E1E] bg-[#0A0A0A]">
      <div className="max-w-5xl mx-auto space-y-12">
        <div className="text-center space-y-4">
          <span className="text-xs font-extrabold text-[#A6CE39] uppercase tracking-widest">Why Switch?</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">ComutShare vs The Alternatives</h2>
        </div>

        <div className="overflow-x-auto rounded-2xl border border-[#1E1E1E]">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-[#121212] border-b border-[#1E1E1E]">
                <th className="text-left px-6 py-4 font-bold text-slate-400 text-xs uppercase tracking-wider">Feature</th>
                <th className="px-6 py-4 font-bold text-slate-500 text-xs uppercase tracking-wider text-center">Solo Driving</th>
                <th className="px-6 py-4 font-bold text-slate-500 text-xs uppercase tracking-wider text-center">Careem / inDrive</th>
                <th className="px-6 py-4 font-bold text-[#A6CE39] text-xs uppercase tracking-wider text-center">ComutShare ✨</th>
              </tr>
            </thead>
            <tbody>
              {rows.map((row, i) => (
                <tr key={i} className={`border-b border-[#1E1E1E] ${row.highlight ? "bg-[#A6CE39]/5" : "bg-[#0A0A0A]"}`}>
                  <td className="px-6 py-4 font-semibold text-slate-300 text-xs">{row.feature}</td>
                  <td className="px-6 py-4 text-center text-slate-500 text-xs">{row.solo}</td>
                  <td className="px-6 py-4 text-center text-slate-500 text-xs">{row.careem}</td>
                  <td className={`px-6 py-4 text-center font-bold text-xs ${row.highlight ? "text-[#A6CE39] text-sm" : "text-[#A6CE39]"}`}>{row.comut}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </section>
  );
}
