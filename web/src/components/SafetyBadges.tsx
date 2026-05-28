export default function SafetyBadges() {
  const badges = [
    { icon: "🪪", title: "CNIC Verified", detail: "Every user's national ID is verified within 4 hours by our audit team" },
    { icon: "🏢", title: "Corporate Email Gate", detail: "Only employees from whitelisted Karachi companies can access the platform" },
    { icon: "🔐", title: "4-Digit Boarding Code", detail: "Escrow payment is released only after verified physical pickup confirmation" },
    { icon: "📍", title: "Live GPS Tracking", detail: "Real-time location shared with pre-registered emergency contacts" },
    { icon: "🆘", title: "SOS Panic Button", detail: "One-tap emergency alert broadcasts live GPS coordinates instantly" },
    { icon: "👩", title: "Women-Only Mode", detail: "Female riders matched exclusively with verified female drivers" },
  ];

  return (
    <section id="safety" className="py-24 px-6 border-t border-[#1E1E1E] bg-[#0C0C0C]">
      <div className="max-w-7xl mx-auto space-y-12">
        <div className="text-center max-w-2xl mx-auto space-y-4">
          <span className="text-xs font-extrabold text-[#A6CE39] uppercase tracking-widest">Trust & Safety</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">6 Layers of Commuter Protection</h2>
          <p className="text-slate-400 text-sm">Your safety is non-negotiable. Every ride is protected by multiple verification checkpoints.</p>
        </div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {badges.map((badge, i) => (
            <div key={i} className="bg-[#121212] border border-[#1E1E1E] rounded-2xl p-6 space-y-3 hover:border-[#A6CE39]/20 transition-all">
              <div className="flex items-center gap-3">
                <span className="text-2xl">{badge.icon}</span>
                <h3 className="font-bold text-white text-sm">{badge.title}</h3>
              </div>
              <p className="text-xs text-slate-500 leading-relaxed">{badge.detail}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
