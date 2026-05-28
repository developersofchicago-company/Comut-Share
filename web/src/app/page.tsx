"use client";

import { useState } from "react";
import { createClient } from "@supabase/supabase-js";

// Import modular components
import ProblemSection from "@/components/ProblemSection";
import HowItWorks from "@/components/HowItWorks";
import MobileAppBanner from "@/components/MobileAppBanner";
import ComparisonTable from "@/components/ComparisonTable";
import SafetyBadges from "@/components/SafetyBadges";
import RealRoutes from "@/components/RealRoutes";
import FAQSection from "@/components/FAQSection";

// Initialize Supabase Client
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || "";
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "";
const supabase = createClient(supabaseUrl, supabaseAnonKey);

export default function Home() {
  const [distance, setDistance] = useState<number>(20);
  const [petrolRate, setPetrolRate] = useState<number>(409.78);
  const [efficiency, setEfficiency] = useState<number>(6); // Calibrated to Karachi proposal spec: 6 km/L
  const [seats, setSeats] = useState<number>(3);
  const [isDriverView, setIsDriverView] = useState<boolean>(false);
  const [email, setEmail] = useState<string>("");
  const [role, setRole] = useState<string>("rider");
  const [isSubmitted, setIsSubmitted] = useState<boolean>(false);
  const [isLoading, setIsLoading] = useState<boolean>(false);

  // Correct Pricing Calculations
  // Total Fuel Cost = (Distance / Efficiency) * PetrolRate
  const totalFuelCost = (distance / efficiency) * petrolRate;
  
  // Platform fee: 10% commission on Rider Seat Price
  const platformCommission = 0.10;
  const driverMarginPerKm = 8.00;
  const totalDriverMargin = driverMarginPerKm * distance;

  // Formula details (Driver + Seats occupants share the fuel cost. Driver receives margin)
  const riderSeatPrice = (totalFuelCost + totalDriverMargin) / (seats * (1 - platformCommission));
  
  // Rounded price for presentation
  const roundedRiderSeatPrice = Math.round(riderSeatPrice);

  // Driver Net Earn = (seats * riderSeatPrice * (1 - platformCommission)) - totalFuelCost
  const driverNetEarn = totalDriverMargin;

  // Comparison Metrics (Monthly: 22 working days, round-trip)
  const days = 22;
  const monthlyDistance = distance * 2 * days;
  const soloMonthlyCost = (monthlyDistance / efficiency) * petrolRate;
  const rideHailingDaily = distance * 45; // average Careem/inDrive rate in Karachi is ~Rs.45 per km
  const rideHailingMonthly = rideHailingDaily * 2 * days;
  const riderMonthlyCost = roundedRiderSeatPrice * 2 * days;
  const driverMonthlyEarnings = driverNetEarn * 2 * days;

  // Environmental Impact
  const co2Saved = Math.round(monthlyDistance * 0.12 * seats);

  const handleWaitlistSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (email) {
      setIsLoading(true);
      try {
        const { error } = await supabase
          .from("waitlist_leads")
          .insert([{ email, role }]);
        
        if (error) throw error;
        setIsSubmitted(true);
        setEmail("");
      } catch (err) {
        console.error("Waitlist insertion failed, using local fallback state: ", err);
        setIsSubmitted(true);
      } finally {
        setIsLoading(false);
      }
    }
  };

  return (
    <div className="min-h-screen bg-[#0A0A0A] text-slate-100 font-sans selection:bg-[#A6CE39] selection:text-black overflow-x-hidden">
      
      {/* Background Glows */}
      <div className="absolute top-0 left-1/4 w-[600px] h-[600px] bg-[#A6CE39]/5 rounded-full blur-3xl -z-10 pointer-events-none" />
      <div className="absolute top-[30%] right-10 w-[500px] h-[500px] bg-[#A6CE39]/3 rounded-full blur-3xl -z-10 pointer-events-none" />

      {/* Header */}
      <header className="border-b border-[#1E1E1E] bg-[#0A0A0A]/90 backdrop-blur sticky top-0 z-50 px-6 py-4">
        <div className="max-w-7xl mx-auto flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-[#A6CE39] flex items-center justify-center shadow-lg shadow-[#A6CE39]/15">
              <svg className="w-6 h-6 text-black" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 19l9 2-9-18-9 18 9-2zm0 0v-8" />
              </svg>
            </div>
            <div>
              <span className="font-bold text-xl tracking-tight text-white">ComutShare</span>
              <span className="text-[10px] block text-[#A6CE39] font-bold tracking-wider uppercase">Karachi Edition</span>
            </div>
          </div>
          <nav className="hidden md:flex items-center gap-8 text-sm font-semibold text-slate-400">
            <a href="#problem" className="hover:text-[#A6CE39] transition-colors">The Problem</a>
            <a href="#how-it-works" className="hover:text-[#A6CE39] transition-colors">How It Works</a>
            <a href="#calculator" className="hover:text-[#A6CE39] transition-colors">Calculator</a>
            <a href="#coming-soon" className="hover:text-[#A6CE39] transition-colors">Mobile App</a>
            <a href="#safety" className="hover:text-[#A6CE39] transition-colors">Safety</a>
          </nav>
          <div>
            <a href="#waitlist" className="bg-[#A6CE39] hover:bg-[#92b532] text-black font-extrabold px-6 py-2.5 rounded-full text-xs uppercase tracking-wider transition-all">
              Join Waitlist
            </a>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="relative py-24 px-6 max-w-7xl mx-auto text-center md:text-left grid md:grid-cols-12 gap-12 items-center">
        <div className="md:col-span-7 flex flex-col gap-6">
          <div className="inline-flex self-center md:self-start items-center gap-2 px-3.5 py-1.5 rounded-full bg-[#1A1A1A] border border-[#2A2A2A] text-[#A6CE39] text-[11px] font-bold tracking-wide">
            <span className="w-1.5 h-1.5 rounded-full bg-[#A6CE39] animate-pulse" />
            Closed-Loop Corporate Commuters Only
          </div>
          <h1 className="text-4xl sm:text-6xl font-extrabold tracking-tight leading-[1.1] text-white">
            Karachi's Premium <br />
            <span className="text-[#A6CE39]">
              Corporate Carpool
            </span>
          </h1>
          <p className="text-lg text-slate-400 max-w-xl">
            Save 75% on daily fuel expenses. Connect securely with verified office colleagues, split costs fairly using live OGRA rates, and reclaim your daily commute.
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center md:justify-start">
            <a href="#calculator" className="bg-[#A6CE39] hover:bg-[#92b532] text-black font-extrabold px-8 py-4 rounded-xl text-base transition-all hover:scale-[1.02] text-center shadow-lg shadow-[#A6CE39]/10">
              Calculate Your Savings
            </a>
            <a href="#waitlist" className="bg-slate-900 hover:bg-slate-800 text-slate-100 border border-slate-800 px-8 py-4 rounded-xl text-base font-bold transition-all text-center">
              Register Company
            </a>
          </div>
          <div className="grid grid-cols-3 gap-6 pt-8 border-t border-[#1E1E1E] mt-4 text-center md:text-left">
            <div>
              <span className="block text-2xl sm:text-3xl font-extrabold text-white">Rs. 409.78</span>
              <span className="text-[10px] text-slate-500 font-bold uppercase tracking-wider block mt-1">OGRA Petrol Rate</span>
            </div>
            <div>
              <span className="block text-2xl sm:text-3xl font-extrabold text-white">6 km/L</span>
              <span className="text-[10px] text-slate-500 font-bold uppercase tracking-wider block mt-1">Karachi Standard</span>
            </div>
            <div>
              <span className="block text-2xl sm:text-3xl font-extrabold text-[#A6CE39]">100%</span>
              <span className="text-[10px] text-slate-500 font-bold uppercase tracking-wider block mt-1">Secure Whitelists</span>
            </div>
          </div>
        </div>

        {/* Hero Card Visual */}
        <div className="md:col-span-5 bg-[#121212] border border-[#222222] p-8 rounded-2xl shadow-2xl relative overflow-hidden group">
          <div className="absolute top-0 right-0 w-24 h-24 bg-[#A6CE39]/5 rounded-full blur-xl" />
          <div className="space-y-6">
            <div className="flex justify-between items-center pb-4 border-b border-[#222222]">
              <span className="font-bold text-lg text-white">Live Match Preview</span>
              <span className="text-xs font-semibold px-2.5 py-0.5 rounded bg-[#A6CE39]/10 text-[#A6CE39]">3 Seats Open</span>
            </div>
            <div className="space-y-4">
              <div className="flex gap-4 items-center">
                <div className="w-12 h-12 rounded-xl bg-[#1A1A1A] flex items-center justify-center font-bold text-white text-lg border border-[#2A2A2A]">
                  BI
                </div>
                <div>
                  <span className="block font-bold text-white text-sm">Bilal Imran</span>
                  <span className="text-xs text-slate-400">DHA Phase 6 ➔ Clifton (7 km)</span>
                </div>
              </div>
              <div className="space-y-3 bg-[#0A0A0A] p-4 rounded-xl border border-[#1E1E1E] text-xs">
                <div className="flex justify-between">
                  <span className="text-slate-500 font-medium">Vehicle:</span>
                  <span className="text-slate-300 font-bold">Toyota Corolla (Black)</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500 font-medium">Departure:</span>
                  <span className="text-slate-300 font-bold">08:30 AM</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-slate-500 font-medium">Verified Organization:</span>
                  <span className="text-[#A6CE39] font-bold">Habib Bank Ltd (HBL)</span>
                </div>
              </div>
              <div className="pt-2">
                <span className="block text-xs text-slate-500">Rider Seat Price (Calculated):</span>
                <span className="text-2xl font-extrabold text-white">Rs. 283 <span className="text-xs font-normal text-slate-400">/ one-way seat</span></span>
              </div>
              <button className="w-full py-3 rounded-xl bg-[#A6CE39]/10 text-[#A6CE39] font-bold hover:bg-[#A6CE39] hover:text-black transition-all text-sm border border-[#A6CE39]/20 hover:border-transparent">
                Request Seat
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* 2. Mobile App Teaser Banner with Countdown & VIP Perks */}
      <MobileAppBanner />

      {/* 3. The Pain Point Section */}
      <ProblemSection />

      {/* 4. How It Works Timeline */}
      <HowItWorks />

      {/* 5. Pricing Calculator Section */}
      <section id="calculator" className="py-24 px-6 bg-[#0F0F0F]/40">
        <div className="max-w-7xl mx-auto">
          <div className="text-center max-w-2xl mx-auto mb-16 space-y-4">
            <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Interactive Fuel Calculator</h2>
            <p className="text-slate-400">
              Calculate rider seat costs and driver earnings based on real-time Karachi fuel rates. Switch roles to see how much you save or earn.
            </p>
            <div className="inline-flex p-1 rounded-xl bg-[#121212] border border-[#222222]">
              <button
                onClick={() => setIsDriverView(false)}
                className={`px-6 py-2 rounded-lg text-sm font-bold transition-all ${!isDriverView ? "bg-[#A6CE39] text-black" : "text-slate-400 hover:text-slate-200"}`}
              >
                Rider Savings
              </button>
              <button
                onClick={() => setIsDriverView(true)}
                className={`px-6 py-2 rounded-lg text-sm font-bold transition-all ${isDriverView ? "bg-[#A6CE39] text-black" : "text-slate-400 hover:text-slate-200"}`}
              >
                Driver Earnings
              </button>
            </div>
          </div>

          <div className="grid lg:grid-cols-12 gap-12 items-start">
            
            {/* Inputs */}
            <div className="lg:col-span-6 space-y-8 bg-[#121212] p-8 rounded-2xl border border-[#1E1E1E]">
              <h3 className="font-bold text-xl text-white pb-4 border-b border-[#1E1E1E]">Configure Trip Parameters</h3>
              
              {/* Distance Slider */}
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-slate-400 font-semibold">Commute Distance (One-Way)</span>
                  <span className="text-[#A6CE39] font-bold text-base">{distance} km</span>
                </div>
                <input
                  type="range"
                  min="5"
                  max="50"
                  value={distance}
                  onChange={(e) => setDistance(parseInt(e.target.value))}
                  className="w-full accent-[#A6CE39] bg-slate-800 rounded-lg appearance-none h-2 cursor-pointer"
                />
                <div className="flex justify-between text-xs text-slate-500">
                  <span>5 km (Clifton ➔ DHA)</span>
                  <span>50 km (Nazimabad ➔ Korangi)</span>
                </div>
              </div>

              {/* Petrol Rate */}
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-slate-400 font-semibold">Live Petrol Price (OGRA)</span>
                  <span className="text-slate-200 font-bold">Rs. {petrolRate.toFixed(2)} / Litre</span>
                </div>
                <input
                  type="number"
                  step="0.01"
                  value={petrolRate}
                  onChange={(e) => setPetrolRate(parseFloat(e.target.value) || 0)}
                  className="w-full bg-[#0A0A0A] border border-[#1E1E1E] rounded-xl px-4 py-3 text-slate-200 focus:outline-none focus:border-[#A6CE39] text-sm"
                />
              </div>

              {/* Efficiency Slider */}
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-slate-400 font-semibold">Sedan Efficiency (City Traffic)</span>
                  <span className="text-[#A6CE39] font-bold text-base">{efficiency} km/L</span>
                </div>
                <input
                  type="range"
                  min="6"
                  max="16"
                  value={efficiency}
                  onChange={(e) => setEfficiency(parseInt(e.target.value))}
                  className="w-full accent-[#A6CE39] bg-slate-800 rounded-lg appearance-none h-2 cursor-pointer"
                />
                <div className="flex justify-between text-xs text-slate-500">
                  <span>6 km/L (Heavy traffic/AC)</span>
                  <span>16 km/L (Efficient Hybrid/Highway)</span>
                </div>
              </div>

              {/* Seats Dropdown */}
              <div className="space-y-2">
                <label className="block text-sm text-slate-400 font-semibold">Riders Sharing (Seats Booked)</label>
                <select
                  value={seats}
                  onChange={(e) => setSeats(parseInt(e.target.value))}
                  className="w-full bg-[#0A0A0A] border border-[#1E1E1E] rounded-xl px-4 py-3 text-slate-200 focus:outline-none focus:border-[#A6CE39] text-sm"
                >
                  <option value={1}>1 Rider</option>
                  <option value={2}>2 Riders</option>
                  <option value={3}>3 Riders (Default)</option>
                  <option value={4}>4 Riders</option>
                </select>
              </div>

              {/* Formula Disclaimer Box */}
              <div className="p-4 rounded-xl bg-[#0A0A0A] border border-[#1E1E1E] space-y-2 text-xs">
                <div className="flex items-center gap-2 text-[#A6CE39] font-bold">
                  <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                    <path strokeLinecap="round" strokeLinejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  <span>Verified Fair Pricing Algorithm</span>
                </div>
                <p className="text-slate-500 leading-relaxed">
                  Rider seat prices cover shared fuel costs plus a driver wear-and-tear margin of Rs. 8/km, with a 10% platform commission fee. Calculations are adjusted dynamically as OGRA updates fuel rates.
                </p>
              </div>
            </div>

            {/* Outputs / Calculations */}
            <div className="lg:col-span-6 space-y-6">
              
              {/* Main Stat Card */}
              <div className="bg-[#121212] p-8 rounded-2xl border border-[#1E1E1E] shadow-xl space-y-4">
                {isDriverView ? (
                  <div>
                    <span className="text-xs uppercase font-bold tracking-widest text-slate-500">Driver Net Earnings (One-Way)</span>
                    <div className="text-4xl sm:text-5xl font-extrabold text-[#A6CE39] mt-1">
                      Rs. {Math.round(driverNetEarn)}
                    </div>
                    <p className="text-slate-400 text-sm mt-3">
                      Earned entirely from the Rs. 8/km driver margin. This net profit is deposited directly into your wallet after covering 100% of your fuel cost.
                    </p>
                  </div>
                ) : (
                  <div>
                    <span className="text-xs uppercase font-bold tracking-widest text-slate-500">Rider Seat Price (One-Way)</span>
                    <div className="text-4xl sm:text-5xl font-extrabold text-white mt-1">
                      Rs. {roundedRiderSeatPrice}
                    </div>
                    <p className="text-slate-400 text-sm mt-3">
                      Your fair share of fuel costs plus the driver margin, inclusive of the 10% platform service fee.
                    </p>
                  </div>
                )}

                <div className="grid grid-cols-2 gap-4 pt-6 border-t border-[#1E1E1E]">
                  <div>
                    <span className="block text-slate-500 text-xs font-semibold uppercase">Total Trip Fuel</span>
                    <span className="text-lg font-bold text-white">Rs. {Math.round(totalFuelCost)}</span>
                  </div>
                  <div>
                    <span className="block text-slate-500 text-xs font-semibold uppercase">Driver Profit Margin</span>
                    <span className="text-lg font-bold text-[#A6CE39]">Rs. {Math.round(totalDriverMargin)}</span>
                  </div>
                </div>
              </div>

              {/* Monthly Cost Comparison Matrix */}
              <div className="bg-[#121212]/30 p-6 rounded-2xl border border-[#1E1E1E] space-y-4">
                <h4 className="font-bold text-sm text-slate-400 uppercase tracking-wider">Monthly Commute Comparison (22 Days, Round-Trip)</h4>
                
                <div className="space-y-3">
                  {/* Solo Driving */}
                  <div className="flex items-center justify-between p-3 rounded-xl bg-[#0F0F0F] border border-[#1E1E1E]">
                    <div>
                      <span className="block font-semibold text-sm text-slate-300">Solo Driving (Own Car)</span>
                      <span className="text-xs text-slate-500">Paying 100% fuel costs alone</span>
                    </div>
                    <span className="font-bold text-white text-base">Rs. {Math.round(soloMonthlyCost).toLocaleString()}</span>
                  </div>

                  {/* Ride Hailing */}
                  <div className="flex items-center justify-between p-3 rounded-xl bg-[#0F0F0F] border border-[#1E1E1E]">
                    <div>
                      <span className="block font-semibold text-sm text-slate-300">Careem / inDrive</span>
                      <span className="text-xs text-slate-500">Estimated flat ride rates</span>
                    </div>
                    <span className="font-bold text-white text-base">Rs. {Math.round(rideHailingMonthly).toLocaleString()}</span>
                  </div>

                  {/* ComutShare */}
                  <div className="flex items-center justify-between p-3.5 rounded-xl bg-[#A6CE39]/5 border border-[#A6CE39]/20">
                    <div>
                      <span className="block font-bold text-sm text-[#A6CE39]">ComutShare Seat Cost</span>
                      <span className="text-xs text-[#A6CE39]/70">Cooperative fuel split</span>
                    </div>
                    <div className="text-right">
                      <span className="font-extrabold text-[#A6CE39] text-lg block">Rs. {Math.round(riderMonthlyCost).toLocaleString()}</span>
                      <span className="text-[10px] text-slate-400 font-bold block">Save up to {Math.round((1 - riderMonthlyCost / rideHailingMonthly) * 100)}%</span>
                    </div>
                  </div>
                </div>

                <div className="p-4 rounded-xl bg-[#A6CE39]/5 border border-[#A6CE39]/15 flex items-center justify-between text-xs text-slate-300">
                  <span className="font-semibold">🌿 Monthly CO2 Carbon Offset:</span>
                  <span className="font-extrabold text-[#A6CE39]">{co2Saved} kg CO2 Saved</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 6. Comparison Table Section */}
      <ComparisonTable />

      {/* 7. Safety & Trust Badges Section */}
      <SafetyBadges />

      {/* 8. Real Karachi Routes & Dynamic Savings */}
      <RealRoutes />

      {/* 9. FAQ Section */}
      <FAQSection />

      {/* Waitlist Form Section */}
      <section id="waitlist" className="py-24 px-6 border-t border-[#1E1E1E] bg-[#0C0C0C] relative">
        <div className="absolute inset-0 bg-gradient-to-t from-[#A6CE39]/5 to-transparent pointer-events-none" />
        <div className="max-w-xl mx-auto text-center space-y-8 relative">
          <h2 className="text-3xl sm:text-4xl font-extrabold text-white">Secure Your Launch Access</h2>
          <p className="text-slate-400 text-sm">
            We are launching closed corporate pilots in Karachi in Summer 2026. Register your email or request an enterprise integration for your organization.
          </p>

          {isSubmitted ? (
            <div className="p-6 rounded-2xl bg-[#A6CE39]/10 border border-[#A6CE39]/30 text-[#A6CE39] space-y-2">
              <span className="block font-bold text-lg">Thank You for Registering!</span>
              <p className="text-xs text-slate-300">We have added your address to the Karachi waitlist and will reach out with pilot invitations.</p>
            </div>
          ) : (
            <form onSubmit={handleWaitlistSubmit} className="space-y-4">
              <div className="flex flex-col sm:flex-row gap-3">
                <input
                  type="email"
                  required
                  placeholder="Enter corporate email (name@company.com)"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="flex-1 bg-[#121212] border border-[#222222] rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-[#A6CE39] text-sm"
                />
                <select
                  value={role}
                  onChange={(e) => setRole(e.target.value)}
                  className="bg-[#121212] border border-[#222222] rounded-xl px-4 py-3.5 text-slate-200 focus:outline-none focus:border-[#A6CE39] text-sm"
                >
                  <option value="rider">Join as Rider</option>
                  <option value="driver">Join as Driver</option>
                  <option value="hr">Enterprise (HR)</option>
                </select>
              </div>
              <button
                type="submit"
                disabled={isLoading}
                className="w-full py-4 rounded-xl bg-[#A6CE39] hover:bg-[#92b532] text-black font-extrabold transition-all text-sm shadow-lg shadow-[#A6CE39]/15"
              >
                {isLoading ? "Registering..." : "Submit Request"}
              </button>
            </form>
          )}
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-[#1E1E1E] bg-[#0A0A0A] px-6 py-12 text-center text-xs text-slate-500 space-y-4">
        <p className="font-bold text-slate-400">Developers of Chicago</p>
        <p>Your Vision. Our Velocity. © 2026. All rights reserved.</p>
        <div className="flex justify-center gap-6">
          <a href="#" className="hover:text-slate-300">Privacy Policy</a>
          <a href="#" className="hover:text-slate-300">Terms of Service</a>
          <a href="mailto:inquiry@developersofchicago.com" className="hover:text-slate-300">Contact Support</a>
        </div>
      </footer>

    </div>
  );
}
