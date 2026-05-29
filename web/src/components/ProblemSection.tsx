export default function ProblemSection() {
  const problems = [
    {
      stat: "Rs. 45/km",
      label: "Careem avg rate",
      desc: "A 20 km commute costs Rs. 900 one-way — Rs. 39,600/month. That is nearly a full mid-level salary gone on transport alone.",
      icon: "🚖",
    },
    {
      stat: "2–3 hrs",
      label: "daily in traffic",
      desc: "Karachi's road network was built for 3 million — it now carries 16 million. Peak-hour commutes from DHA to I.I. Chundrigar regularly exceed 90 minutes one-way.",
      icon: "🚦",
    },
    {
      stat: "Zero trust",
      label: "in stranger rides",
      desc: "Existing carpools rely on unverified Facebook groups. No identity checks, no corporate accountability, no safety net if something goes wrong.",
      icon: "⚠️",
    },
  ];

  return (
    <section id="problem" className="py-24 px-6">
      <div className="max-w-7xl mx-auto">
        <div className="text-center max-w-2xl mx-auto mb-16 space-y-4">
          <span className="text-xs uppercase font-bold tracking-widest text-[#A6CE39]">The Problem</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Karachi&apos;s commute is broken</h2>
          <p className="text-slate-400">
            Every working day, hundreds of thousands of corporate employees burn money, time, and carbon making the exact same journey — alone.
          </p>
        </div>
        <div className="grid md:grid-cols-3 gap-6">
          {problems.map((p) => (
            <div key={p.label} className="bg-[#0F0F0F] border border-[#1E1E1E] rounded-2xl p-8 space-y-4 hover:border-[#A6CE39]/15 transition-all">
              <span className="text-4xl">{p.icon}</span>
              <div>
                <span className="block text-3xl font-extrabold text-white">{p.stat}</span>
                <span className="text-xs uppercase font-bold tracking-wider text-[#A6CE39]">{p.label}</span>
              </div>
              <p className="text-slate-400 text-sm leading-relaxed">{p.desc}</p>
            </div>
          ))}
        </div>
        <div className="mt-12 p-6 rounded-2xl bg-[#A6CE39]/5 border border-[#A6CE39]/15 text-center">
          <p className="text-slate-300 text-sm">
            <span className="font-bold text-white">ComutShare solves all three</span> — by pooling verified corporate colleagues travelling the same route, splitting real OGRA-anchored fuel costs, and keeping every ride inside a trusted closed loop.
          </p>
        </div>
      </div>
    </section>
  );
}
