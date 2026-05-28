"use client";

import { useState } from "react";

const faqs = [
  { q: "Is my phone number shared with drivers?", a: "No. All communication happens through secure in-app chat. Your personal phone number is never revealed to any other user." },
  { q: "What if my company isn't whitelisted yet?", a: "Your HR department can request an enterprise partnership through our waitlist form. We onboard new companies within 48 hours of verification." },
  { q: "How is the seat price calculated?", a: "Prices are calculated using the official OGRA petrol rate, divided by the number of sharing seats, plus a small Rs. 8/km driver wear-and-tear margin and a 10% platform service fee. Everything is transparent." },
  { q: "What happens if the driver cancels last minute?", a: "Your escrowed wallet payment is instantly refunded in full. Repeat cancellers receive reputation penalties and may be suspended from the platform." },
  { q: "Is there a minimum wallet balance required?", a: "Yes, you need at least one ride's worth of balance before booking. Top-up instantly via JazzCash or EasyPaisa." },
  { q: "Can women commuters feel safe using this?", a: "Absolutely. We offer a dedicated Women-Only mode where female riders are matched exclusively with verified female drivers. Combined with CNIC verification, live GPS tracking, and the SOS panic button, safety is our top priority." },
  { q: "Can I use ComutShare for non-office trips?", a: "Currently, ComutShare is optimized for weekday office commutes. Weekend and leisure ride features are planned for Year 2 expansion." },
];

export default function FAQSection() {
  const [openIndex, setOpenIndex] = useState<number | null>(null);

  return (
    <section className="py-24 px-6 border-t border-[#1E1E1E] bg-[#0A0A0A]">
      <div className="max-w-3xl mx-auto space-y-12">
        <div className="text-center space-y-4">
          <span className="text-xs font-extrabold text-[#A6CE39] uppercase tracking-widest">Questions?</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Frequently Asked Questions</h2>
        </div>

        <div className="space-y-3">
          {faqs.map((faq, i) => (
            <div key={i} className="bg-[#121212] border border-[#1E1E1E] rounded-xl overflow-hidden transition-all">
              <button
                onClick={() => setOpenIndex(openIndex === i ? null : i)}
                className="w-full flex items-center justify-between px-6 py-5 text-left"
              >
                <span className="font-bold text-sm text-slate-200 pr-4">{faq.q}</span>
                <span className={`text-[#A6CE39] text-lg font-bold transition-transform shrink-0 ${openIndex === i ? "rotate-45" : ""}`}>+</span>
              </button>
              {openIndex === i && (
                <div className="px-6 pb-5 -mt-1">
                  <p className="text-xs text-slate-400 leading-relaxed">{faq.a}</p>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
