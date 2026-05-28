export default function ProblemSection() {
  const stats = [
    { icon: "🔥", stat: "Rs. 820/day", label: "Average 20km commuter burns in petrol alone" },
    { icon: "⏰", stat: "2.5 hrs/day", label: "Average Karachi round-trip commute time" },
    { icon: "🌫️", stat: "4.8 kg/day", label: "CO2 footprint of solo driving daily" },
  ];

  return (
    <section id="problem" className="py-24 px-6 border-t border-[#1E1E1E] bg-[#0A0A0A]">
      <div className="max-w-7xl mx-auto space-y-12">
        <div className="text-center max-w-3xl mx-auto space-y-4">
          <span className="text-xs font-extrabold text-red-400 uppercase tracking-widest">The Daily Reality</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white leading-tight">
            Every Morning, 4 Million Karachiites <br className="hidden sm:block" />
            <span className="text-red-400">Burn Money Sitting in Traffic</span>
          </h2>
        </div>

        <div className="grid sm:grid-cols-3 gap-6">
          {stats.map((item, i) => (
            <div key={i} className="bg-[#121212] border border-[#1E1E1E] rounded-2xl p-8 text-center space-y-3 hover:border-[#A6CE39]/20 transition-all">
              <span className="text-4xl block">{item.icon}</span>
              <span className="text-3xl font-extrabold text-white block">{item.stat}</span>
              <span className="text-xs text-slate-500 block leading-relaxed">{item.label}</span>
            </div>
          ))}
        </div>

        <p className="text-center text-slate-400 text-sm max-w-2xl mx-auto italic leading-relaxed">
          &ldquo;What if your office colleague 3 streets away is driving the same route at the same time — and you could split the cost?&rdquo;
        </p>
      </div>
    </section>
  );
}
