export default function RealRoutes() {
  const petrolRate = 409.78;
  const efficiency = 6;
  const seats = 3;
  const commission = 0.10;
  const marginPerKm = 8;

  const calcSeat = (km: number) => {
    const fuel = (km / efficiency) * petrolRate;
    const margin = marginPerKm * km;
    return Math.round((fuel + margin) / (seats * (1 - commission)));
  };
  const calcSolo = (km: number) => Math.round((km / efficiency) * petrolRate);

  const routes = [
    { from: "DHA Phase 6", to: "Clifton", km: 7 },
    { from: "Gulshan-e-Iqbal", to: "I.I. Chundrigar Road", km: 15 },
    { from: "North Nazimabad", to: "Korangi Industrial", km: 25 },
    { from: "Malir Cantt", to: "Shahrah-e-Faisal", km: 20 },
  ];

  return (
    <section className="py-24 px-6 border-t border-[#1E1E1E] bg-[#0C0C0C]">
      <div className="max-w-5xl mx-auto space-y-12">
        <div className="text-center space-y-4">
          <span className="text-xs font-extrabold text-[#A6CE39] uppercase tracking-widest">Real Numbers</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Real Karachi Routes, Real Savings</h2>
          <p className="text-slate-400 text-sm">Find your daily commute and see exactly how much you save per trip.</p>
        </div>

        <div className="grid sm:grid-cols-2 gap-6">
          {routes.map((r, i) => {
            const solo = calcSolo(r.km);
            const seat = calcSeat(r.km);
            const pct = Math.round((1 - seat / solo) * 100);
            return (
              <div key={i} className="bg-[#121212] border border-[#1E1E1E] rounded-2xl p-6 space-y-4 hover:border-[#A6CE39]/20 transition-all">
                <div className="flex items-center gap-2 text-xs">
                  <span className="w-2 h-2 rounded-full bg-[#A6CE39]" />
                  <span className="text-slate-300 font-bold">{r.from}</span>
                  <span className="text-slate-600">➔</span>
                  <span className="text-slate-300 font-bold">{r.to}</span>
                  <span className="ml-auto text-slate-500 font-semibold">{r.km} km</span>
                </div>
                <div className="flex items-end justify-between">
                  <div>
                    <span className="text-xs text-slate-500 block">Solo: <span className="line-through">Rs. {solo}</span></span>
                    <span className="text-xl font-extrabold text-white block mt-1">Rs. {seat} <span className="text-xs font-normal text-slate-400">/ seat</span></span>
                  </div>
                  <span className="bg-[#A6CE39]/10 border border-[#A6CE39]/20 text-[#A6CE39] font-extrabold text-xs px-3 py-1.5 rounded-lg">
                    Save {pct}%
                  </span>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
