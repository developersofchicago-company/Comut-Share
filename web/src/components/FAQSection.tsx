"use client";

import { useState } from "react";

const faqs = [
  {
    q: "Who can join ComutShare?",
    a: "ComutShare is exclusively for employees of verified corporate organisations in Karachi. You must register with your company email domain and pass a one-time CNIC identity verification. Personal email addresses (Gmail, Yahoo, etc.) are blocked.",
  },
  {
    q: "How is the seat price calculated?",
    a: "Seat price = (Total fuel cost + Driver margin at Rs. 8/km) ÷ (seats × 0.9). Fuel cost is derived from OGRA's official petrol rate (currently Rs. 409.78/L) and Karachi's average 6 km/L city efficiency. Prices update automatically when OGRA announces new rates.",
  },
  {
    q: "What if the driver cancels last minute?",
    a: "If a driver cancels within 2 hours of departure, all riders receive a full refund to their ComutShare wallet instantly. Repeat cancellations result in temporary account restrictions and review by our trust team.",
  },
  {
    q: "Is my payment secure?",
    a: "Yes. Rider payments are held in escrow inside the app and are only released to the driver after successful drop-off confirmation (4-digit pickup code + GPS verification). Neither party can access the funds mid-trip.",
  },
  {
    q: "Can my company subsidise rides?",
    a: "Yes. Our corporate HR dashboard lets your company set a per-ride subsidy (e.g. Rs. 50/ride) and a monthly cap per employee. Subsidies are deducted from your company's monthly invoice automatically — no manual reimbursements.",
  },
  {
    q: "When is the mobile app launching?",
    a: "We are targeting August 2026 for the closed corporate pilot. Early registrants on the waitlist will receive priority access and VIP onboarding support. The countdown timer on this page shows the exact days remaining.",
  },
  {
    q: "What cities will ComutShare operate in?",
    a: "Karachi is our first and primary market. We have designed the platform specifically around Karachi's road network, corporate districts, and OGRA fuel pricing. Lahore and Islamabad expansions are planned for Q1 2027.",
  },
];

export default function FAQSection() {
  const [open, setOpen] = useState<number | null>(null);

  return (
    <section className="py-24 px-6 bg-[#0F0F0F]/40">
      <div className="max-w-3xl mx-auto">
        <div className="text-center mb-16 space-y-4">
          <span className="text-xs uppercase font-bold tracking-widest text-[#A6CE39]">FAQ</span>
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Frequently asked questions</h2>
        </div>
        <div className="space-y-3">
          {faqs.map((faq, i) => (
            <div key={i} className="border border-[#1E1E1E] rounded-2xl overflow-hidden">
              <button
                onClick={() => setOpen(open === i ? null : i)}
                className="w-full flex items-center justify-between px-6 py-4 text-left hover:bg-[#1A1A1A]/40 transition-all"
              >
                <span className="font-semibold text-white text-sm">{faq.q}</span>
                <svg
                  className={`w-4 h-4 text-[#A6CE39] shrink-0 ml-4 transition-transform ${open === i ? "rotate-180" : ""}`}
                  fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}
                >
                  <path strokeLinecap="round" strokeLinejoin="round" d="M19 9l-7 7-7-7" />
                </svg>
              </button>
              {open === i && (
                <div className="px-6 pb-5 border-t border-[#1A1A1A]">
                  <p className="text-sm text-slate-400 leading-relaxed pt-4">{faq.a}</p>
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
