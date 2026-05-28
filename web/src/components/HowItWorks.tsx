export default function HowItWorks() {
  const steps = [
    { num: "01", icon: "🏢", title: "Verify Your Company", desc: "Sign up with your corporate email. Only employees from whitelisted Karachi companies are accepted." },
    { num: "02", icon: "🔍", title: "Find or Offer a Ride", desc: "Search commuters on your route, or publish your own daily ride offer with dynamic pricing." },
    { num: "03", icon: "🤝", title: "Match & Board Safely", desc: "Get matched, receive a 4-digit boarding code, and confirm pickup with escrow protection." },
    { num: "04", icon: "💰", title: "Split & Save", desc: "Fuel costs are split fairly via OGRA-anchored pricing. Driver earns, rider saves 75%." },
  ];

  return (
    <section id="how-it-works" className="py-24 px-6 border-t border-[#1E1E1E] bg-[#0C0C0C]">
      <div className="max-w-7xl mx-auto space-y-16">
        <div className="text-center max-w-2xl mx-auto space-y-4">
          <span className="text-xs font-extrabold text-[#A6CE39] uppercase tracking-widest">Simple Process</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">How ComutShare Works</h2>
          <p className="text-slate-400 text-sm">From signup to savings in 4 simple steps. No complexity, no hidden fees.</p>
        </div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6">
          {steps.map((step, i) => (
            <div key={i} className="relative bg-[#121212] border border-[#1E1E1E] rounded-2xl p-8 space-y-4 hover:border-[#A6CE39]/30 transition-all group">
              <span className="text-[10px] font-extrabold text-[#A6CE39]/40 uppercase tracking-widest absolute top-4 right-4">{step.num}</span>
              <span className="text-3xl block">{step.icon}</span>
              <h3 className="font-bold text-white text-base">{step.title}</h3>
              <p className="text-xs text-slate-500 leading-relaxed">{step.desc}</p>
              {i < 3 && <div className="hidden lg:block absolute -right-3 top-1/2 -translate-y-1/2 text-[#A6CE39]/30 text-xl z-10">➔</div>}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
