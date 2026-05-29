export default function SafetyBadges() {
  const badges = [
    {
      icon: "🪪",
      title: "CNIC Verified",
      desc: "Every driver and rider submits their National Identity Card before their first ride. Our admin team manually reviews all documents.",
    },
    {
      icon: "🏢",
      title: "Corporate Email Only",
      desc: "Registration requires a verified company domain email. Personal Gmail, Yahoo, and Hotmail accounts are blocked at sign-up.",
    },
    {
      icon: "🔒",
      title: "Closed Whitelists",
      desc: "Rides are only visible to colleagues from the same verified organisation. No public listings — ever.",
    },
    {
      icon: "📍",
      title: "Live Ride Tracking",
      desc: "Share your live trip status with a trusted contact. SOS alert sends your GPS coordinates to emergency services and platform admins.",
    },
    {
      icon: "💬",
      title: "In-App Chat Only",
      desc: "All communications happen inside the app. No phone numbers shared until both parties consent. Full message history retained.",
    },
    {
      icon: "⭐",
      title: "Two-Way Ratings",
      desc: "Both driver and rider rate every trip. Low-rated users are flagged and reviewed within 48 hours. Repeat offenders are removed.",
    },
  ];

  return (
    <section id="safety" className="py-24 px-6 bg-[#0F0F0F]/40">
      <div className="max-w-7xl mx-auto">
        <div className="text-center max-w-2xl mx-auto mb-16 space-y-4">
          <span className="text-xs uppercase font-bold tracking-widest text-[#A6CE39]">Safety & Trust</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Built for corporate accountability</h2>
          <p className="text-slate-400">Every layer of ComutShare is designed to ensure you only share a ride with colleagues you can trust.</p>
        </div>
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {badges.map((b) => (
            <div key={b.title} className="bg-[#0F0F0F] border border-[#1E1E1E] rounded-2xl p-6 space-y-3 hover:border-[#A6CE39]/20 transition-all group">
              <div className="w-12 h-12 rounded-xl bg-[#A6CE39]/10 flex items-center justify-center text-2xl group-hover:bg-[#A6CE39]/15 transition-all">
                {b.icon}
              </div>
              <h3 className="font-bold text-white">{b.title}</h3>
              <p className="text-sm text-slate-400 leading-relaxed">{b.desc}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
