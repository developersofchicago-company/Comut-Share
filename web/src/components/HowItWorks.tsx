export default function HowItWorks() {
  const steps = [
    {
      step: "01",
      title: "Verify your corporate identity",
      desc: "Sign up with your company email domain. Upload your CNIC for a one-time background check. Your account is permanently linked to your organisation.",
      tag: "Identity & Trust",
    },
    {
      step: "02",
      title: "Post or find a ride",
      desc: "Drivers post their daily route, departure time, and available seats. Riders search by pickup proximity (2 km radius) and office destination (3 km radius).",
      tag: "Smart Matching",
    },
    {
      step: "03",
      title: "Book and pay into escrow",
      desc: "Riders request a seat. The seat price is auto-calculated from live OGRA petrol rates. Payment is held in escrow — released to the driver only after drop-off.",
      tag: "Fair Pricing",
    },
    {
      step: "04",
      title: "Ride, verify, and rate",
      desc: "Driver shares a 4-digit pickup code. At the destination, the rider confirms arrival, releasing funds. Both parties rate each other to build community trust.",
      tag: "Accountability",
    },
  ];

  return (
    <section id="how-it-works" className="py-24 px-6 bg-[#0F0F0F]/40">
      <div className="max-w-7xl mx-auto">
        <div className="text-center max-w-2xl mx-auto mb-16 space-y-4">
          <span className="text-xs uppercase font-bold tracking-widest text-[#A6CE39]">How It Works</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Four steps to a better commute</h2>
          <p className="text-slate-400">Every ride is verified, priced transparently, and settled automatically.</p>
        </div>
        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 relative">
          {steps.map((s, i) => (
            <div key={s.step} className="relative bg-[#0F0F0F] border border-[#1E1E1E] rounded-2xl p-6 space-y-4">
              {i < steps.length - 1 && (
                <div className="hidden lg:block absolute top-8 left-full w-6 border-t border-dashed border-[#2A2A2A] z-10" />
              )}
              <div className="flex items-center justify-between">
                <span className="text-4xl font-extrabold text-[#A6CE39]/20">{s.step}</span>
                <span className="text-[10px] font-bold uppercase tracking-wider px-2 py-1 rounded bg-[#A6CE39]/10 text-[#A6CE39]">{s.tag}</span>
              </div>
              <h3 className="font-bold text-white text-base">{s.title}</h3>
              <p className="text-sm text-slate-400 leading-relaxed">{s.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
