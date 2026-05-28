"use client";

import { useEffect, useState } from "react";
import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const supabase = supabaseUrl && supabaseAnonKey ? createClient(supabaseUrl, supabaseAnonKey) : null;

interface Employee {
  id: string;
  full_name: string | null;
  email: string | null;
  is_driver: boolean;
  cnic_verified: boolean;
  reputation_score: number;
  created_at: string;
}

export default function EmployeesPage() {
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState("");

  useEffect(() => {
    async function load() {
      if (!supabase) {
        // Fallback demo data
        setEmployees(demoEmployees);
        setIsLoading(false);
        return;
      }
      try {
        const { data } = await supabase
          .from("users")
          .select("id, full_name, email, is_driver, cnic_verified, reputation_score, created_at")
          .order("created_at", { ascending: false })
          .limit(100);
        setEmployees((data as Employee[]) ?? demoEmployees);
      } catch {
        setEmployees(demoEmployees);
      } finally {
        setIsLoading(false);
      }
    }
    load();
  }, []);

  const filtered = employees.filter(
    (e) =>
      (e.full_name ?? "").toLowerCase().includes(search.toLowerCase()) ||
      (e.email ?? "").toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h2 className="text-2xl font-extrabold text-white">Verified Employees</h2>
        <input
          type="text"
          placeholder="Search by name or email..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="bg-[#0F0F0F] border border-[#1E1E1E] rounded-xl px-4 py-2 text-sm text-slate-200 focus:outline-none focus:border-[#A6CE39] w-64"
        />
      </div>

      <div className="rounded-2xl border border-[#1E1E1E] bg-[#0F0F0F] overflow-hidden">
        <table className="w-full text-sm">
          <thead className="bg-[#1A1A1A] text-xs uppercase tracking-wider text-slate-500">
            <tr>
              <th className="text-left px-6 py-3 font-bold">Employee</th>
              <th className="text-left px-6 py-3 font-bold">Email</th>
              <th className="text-left px-6 py-3 font-bold">Role</th>
              <th className="text-left px-6 py-3 font-bold">CNIC</th>
              <th className="text-left px-6 py-3 font-bold">Rating</th>
              <th className="text-left px-6 py-3 font-bold">Joined</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-[#1E1E1E]">
            {isLoading ? (
              <tr><td colSpan={6} className="text-center text-slate-500 py-8">Loading...</td></tr>
            ) : filtered.length === 0 ? (
              <tr><td colSpan={6} className="text-center text-slate-500 py-8">No employees found</td></tr>
            ) : (
              filtered.map((e) => (
                <tr key={e.id} className="hover:bg-[#1A1A1A]/40">
                  <td className="px-6 py-3 font-semibold text-white">{e.full_name ?? "—"}</td>
                  <td className="px-6 py-3 text-slate-400">{e.email ?? "—"}</td>
                  <td className="px-6 py-3">
                    <span className={`text-xs font-bold px-2 py-0.5 rounded ${e.is_driver ? "bg-blue-500/10 text-blue-400" : "bg-slate-500/10 text-slate-400"}`}>
                      {e.is_driver ? "Driver" : "Rider"}
                    </span>
                  </td>
                  <td className="px-6 py-3">
                    {e.cnic_verified ? (
                      <span className="text-xs font-bold text-[#A6CE39]">✓ Verified</span>
                    ) : (
                      <span className="text-xs font-bold text-orange-400">⏳ Pending</span>
                    )}
                  </td>
                  <td className="px-6 py-3 text-white font-bold">★ {e.reputation_score?.toFixed(1) ?? "—"}</td>
                  <td className="px-6 py-3 text-slate-500 text-xs">
                    {new Date(e.created_at).toLocaleDateString()}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

const demoEmployees: Employee[] = [
  { id: "1", full_name: "Bilal Imran", email: "bilal@hbl.com", is_driver: true, cnic_verified: true, reputation_score: 4.9, created_at: "2026-05-01T00:00:00Z" },
  { id: "2", full_name: "Ayesha Khan", email: "ayesha@hbl.com", is_driver: false, cnic_verified: true, reputation_score: 5.0, created_at: "2026-05-03T00:00:00Z" },
  { id: "3", full_name: "Hassan Raza", email: "hassan@hbl.com", is_driver: true, cnic_verified: true, reputation_score: 4.7, created_at: "2026-05-05T00:00:00Z" },
  { id: "4", full_name: "Fatima Sheikh", email: "fatima@hbl.com", is_driver: false, cnic_verified: false, reputation_score: 5.0, created_at: "2026-05-22T00:00:00Z" },
  { id: "5", full_name: "Omar Siddiqui", email: "omar@hbl.com", is_driver: true, cnic_verified: true, reputation_score: 4.8, created_at: "2026-05-12T00:00:00Z" },
];
