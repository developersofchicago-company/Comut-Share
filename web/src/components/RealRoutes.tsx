export default function RealRoutes() {
  const routes = [
    {
      from: "DHA Phase 6",
      to: "Shahrah-e-Faisal",
      km: 14,
      riders: 28,
      seatPrice: 198,
      soloPrice: 961,
      saving: 80,
    },
    {
      from: "Gulshan-e-Iqbal",
      to: "I.I. Chundrigar Road",
      km: 18,
      riders: 19,
      seatPrice: 255,
      soloPrice: 1234,
      saving: 79,
    },
    {
      from: "Clifton Block 5",
      to: "Korangi Industrial Area",
      km: 22,
      riders: 14,
      seatPrice: 311,
      soloPrice: 1509,
      saving: 79,
    },
    {
      from: "North Nazimabad",
      to: "Shahrah-e-Faisal",
      km: 16,
      riders: 11,
      seatPrice: 226,
      soloPrice: 1097,
      saving: 79,
    },
    {
      from: "Scheme 33",
      to: "Clifton Block 9",
      km: 28,
      riders: 9,
      seatPrice: 396,
      soloPrice: 1921,
      saving: 79,
    },
    {
      from: "Malir Cantonment",
      to: "I.I. Chundrigar Road",
      km: 26,
      riders: 7,
      seatPrice: 368,
      soloPrice: 1784,
      saving: 79,
    },
  ];

  return (
    <section className="py-24 px-6">
      <div className="max-w-7xl mx-auto">
        <div className="text-center max-w-2xl mx-auto mb-16 space-y-4">
          <span className="text-xs uppercase font-bold tracking-widest text-[#A6CE39]">Real Karachi Routes</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Your route is already active</h2>
          <p className="text-slate-400">
            These are the top commuter corridors in Karachi. Savings calculated at OGRA rate Rs. 409.78/L, 3 riders, 6 km/L city efficiency.
          </p>
        </div>
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-4">
          {routes.map((r) => (
            <div key={r.from} className="bg-[#0F0F0F] border border-[#1E1E1E] rounded-2xl p-6 space-y-4 hover:border-[#A6CE39]/20 transition-all">
              <div className="space-y-1">
                <div className="flex items-center gap-2 text-sm">
                  <span className="w-2 h-2 rounded-full bg-[#A6CE39]" />
                  <span className="font-semibold text-white">{r.from}</span>
                </div>
                <div className="ml-3 border-l border-dashed border-[#2A2A2A] pl-3 py-1">
                  <span className="text-xs text-slate-500">{r.km} km · {r.riders} active riders</span>
                </div>
                <div className="flex items-center gap-2 text-sm">
                  <span className="w-2 h-2 rounded-full bg-slate-600" />
                  <span className="font-semibold text-slate-300">{r.to}</span>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3 pt-2 border-t border-[#1A1A1A]">
                <div>
                  <span className="block text-[10px] uppercase font-bold tracking-wider text-slate-500">Seat price</span>
                  <span className="font-extrabold text-[#A6CE39]">Rs. {r.seatPrice}</span>
                </div>
                <div>
                  <span className="block text-[10px] uppercase font-bold tracking-wider text-slate-500">vs solo</span>
                  <span className="font-extrabold text-white">Rs. {r.soloPrice.toLocaleString()}</span>
                </div>
              </div>
              <div className="text-xs font-bold text-[#A6CE39] bg-[#A6CE39]/5 border border-[#A6CE39]/10 rounded-lg px-3 py-1.5 text-center">
                Save {r.saving}% vs driving alone
              </div>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
