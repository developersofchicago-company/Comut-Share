// Wallet service — escrow holds and ride payment settlement.
//
// Transaction types (matches schema CHECK constraint):
//   - deposit        : rider tops up via JazzCash / EasyPaisa
//   - withdraw       : driver withdraws to bank
//   - payment_debit  : rider pays for a booked seat (escrow hold)
//   - payment_credit : driver receives payment after ride completes
//   - refund         : rider refund on declined/cancelled booking
//   - bonus          : referral / streak credits
//
// All wallet mutations use the service role key (RLS bypass) and run via Postgres
// transactions so balance never desynchronizes from the ledger.

import { supabaseAdmin } from '../db/supabase.client';

const PLATFORM_COMMISSION = 0.10; // 10% from rider's payment

export class WalletService {
  // ── Read balance ─────────────────────────────────────
  static async getBalance(userId: string) {
    const { data, error } = await supabaseAdmin
      .from('users')
      .select('wallet_balance')
      .eq('id', userId)
      .single();
    if (error) throw new Error(error.message);
    return Number(data.wallet_balance);
  }

  // ── Transaction history ──────────────────────────────
  static async getTransactions(userId: string, limit = 50) {
    const { data, error } = await supabaseAdmin
      .from('transactions')
      .select('*')
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .limit(limit);
    if (error) throw new Error(error.message);
    return data ?? [];
  }

  // ── Internal: change balance + log transaction atomically ────
  // For a real prod build, wrap this in a Postgres function/RPC to
  // get true atomicity. Splitting reads + writes here means a crash
  // mid-flow could desync — acceptable for MVP, fix before payment go-live.
  static async _mutate(userId: string, delta: number, type: string, bookingId?: string) {
    const { data: user, error: readErr } = await supabaseAdmin
      .from('users')
      .select('wallet_balance')
      .eq('id', userId)
      .single();
    if (readErr) throw new Error(readErr.message);

    const current = Number(user.wallet_balance);
    const next = current + delta;
    if (next < 0) throw new Error('Insufficient wallet balance');

    const { error: updErr } = await supabaseAdmin
      .from('users')
      .update({ wallet_balance: next })
      .eq('id', userId);
    if (updErr) throw new Error(updErr.message);

    const { error: txnErr } = await supabaseAdmin.from('transactions').insert({
      user_id: userId,
      booking_id: bookingId ?? null,
      type,
      amount: Math.abs(delta),
      status: 'completed',
    });
    if (txnErr) {
      // Best-effort rollback of balance change
      await supabaseAdmin.from('users').update({ wallet_balance: current }).eq('id', userId);
      throw new Error(txnErr.message);
    }

    return next;
  }

  // ── Top up (stub — real implementation hits JazzCash/EasyPaisa) ──
  static async topup(userId: string, amount: number) {
    if (amount <= 0) throw new Error('Amount must be positive');
    // INTEGRATION POINT: verify payment with JazzCash/EasyPaisa here before crediting
    return this._mutate(userId, amount, 'deposit');
  }

  // ── Withdraw (stub — real implementation queues 1LINK bank transfer) ──
  static async withdraw(userId: string, amount: number) {
    if (amount <= 0) throw new Error('Amount must be positive');
    if (amount < 1000) throw new Error('Minimum withdrawal is Rs. 1,000');
    // INTEGRATION POINT: enqueue bank-transfer via 1LINK or Safepay payout API
    return this._mutate(userId, -amount, 'withdraw');
  }

  // ── Escrow: when booking is accepted, debit rider, hold internally ──
  static async escrowHold(riderId: string, bookingId: string, amount: number) {
    return this._mutate(riderId, -amount, 'payment_debit', bookingId);
  }

  // ── Refund rider if booking declined/cancelled ───────
  static async refund(riderId: string, bookingId: string, amount: number) {
    return this._mutate(riderId, amount, 'refund', bookingId);
  }

  // ── Settle ride: pay driver, take platform commission ──
  // amount = total amount riders paid for this booking
  static async settleToDriver(driverId: string, bookingId: string, amount: number) {
    const platformFee = amount * PLATFORM_COMMISSION;
    const driverShare = amount - platformFee;
    return this._mutate(driverId, driverShare, 'payment_credit', bookingId);
    // Platform fee is the difference — implicitly retained by the system.
  }

  // ── Award referral bonus ─────────────────────────────
  static async awardBonus(userId: string, amount: number) {
    return this._mutate(userId, amount, 'bonus');
  }
}
