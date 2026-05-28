// Bookings service — handles seat requests, accept/decline, pickup verification.
//
// Lifecycle:
//   requested → accepted → started → completed
//                ↘ declined
//                ↘ cancelled (rider cancels before pickup)
//
// On accept: decrement ride.seats_available, hold payment in escrow (wallet service).
// On decline / cancel: increment seats back, refund escrow.
// On pickup verify (4-digit code): mark booking 'started'.
// On complete: release payment to driver (wallet service handles fee split).

import { supabaseAdmin } from '../db/supabase.client';
import { RidesService } from './rides.service';

export interface CreateBookingInput {
  ride_id: string;
  seats_booked?: number;
  emergency_contact?: string;
  message?: string;
}

/** Generate a 4-digit numeric pickup code. */
function generatePickupCode(): string {
  return Math.floor(1000 + Math.random() * 9000).toString();
}

export class BookingsService {
  // ── Rider requests a seat ────────────────────────────
  static async create(riderId: string, input: CreateBookingInput) {
    // Verify ride exists and has seats
    const { data: ride, error: rideErr } = await supabaseAdmin
      .from('rides')
      .select('id, driver_id, seats_available, status')
      .eq('id', input.ride_id)
      .single();

    if (rideErr || !ride) throw new Error('Ride not found');
    if (ride.status !== 'published') throw new Error(`Cannot book a ${ride.status} ride`);
    if (ride.driver_id === riderId) throw new Error('Cannot book your own ride');
    const seatsRequested = input.seats_booked ?? 1;
    if ((ride.seats_available as number) < seatsRequested) {
      throw new Error('Not enough seats available');
    }

    // Prevent duplicate active bookings by same rider on same ride
    const { data: existing } = await supabaseAdmin
      .from('bookings')
      .select('id, status')
      .eq('ride_id', input.ride_id)
      .eq('rider_id', riderId)
      .in('status', ['requested', 'accepted', 'started']);

    if (existing && existing.length > 0) {
      throw new Error('You already have an active booking on this ride');
    }

    const insertPayload = {
      ride_id: input.ride_id,
      rider_id: riderId,
      seats_booked: seatsRequested,
      verification_code: generatePickupCode(),
      emergency_contact: input.emergency_contact ?? null,
      status: 'requested',
    };

    const { data, error } = await supabaseAdmin
      .from('bookings')
      .insert(insertPayload)
      .select('*')
      .single();

    if (error) throw new Error(`Failed to create booking: ${error.message}`);
    return data;
  }

  // ── Driver accepts / declines ────────────────────────
  static async updateStatus(bookingId: string, requesterId: string, newStatus: string) {
    const validStatuses = ['accepted', 'declined', 'cancelled', 'completed'];
    if (!validStatuses.includes(newStatus)) {
      throw new Error(`Invalid status: ${newStatus}`);
    }

    // Fetch booking + ride to verify the actor's right to perform this transition
    const { data: booking, error: readErr } = await supabaseAdmin
      .from('bookings')
      .select('*, rides:ride_id(driver_id, id)')
      .eq('id', bookingId)
      .single();

    if (readErr || !booking) throw new Error('Booking not found');

    const isDriver = (booking as any).rides?.driver_id === requesterId;
    const isRider = booking.rider_id === requesterId;
    if (!isDriver && !isRider) throw new Error('Not authorized to modify this booking');

    // Permission rules
    if ((newStatus === 'accepted' || newStatus === 'declined') && !isDriver) {
      throw new Error('Only the driver can accept/decline bookings');
    }
    if (newStatus === 'cancelled' && !isRider && !isDriver) {
      throw new Error('Not authorized to cancel');
    }

    // Update booking
    const { data: updated, error: updErr } = await supabaseAdmin
      .from('bookings')
      .update({ status: newStatus })
      .eq('id', bookingId)
      .select('*')
      .single();
    if (updErr) throw new Error(`Failed to update booking: ${updErr.message}`);

    // Side effects on the ride's seat count
    if (newStatus === 'accepted') {
      await RidesService.decrementSeats(booking.ride_id, booking.seats_booked);
    } else if ((newStatus === 'declined' || newStatus === 'cancelled') && booking.status === 'accepted') {
      // Was previously accepted → return seats
      await RidesService.incrementSeats(booking.ride_id, booking.seats_booked);
    }

    return updated;
  }

  // ── Driver verifies pickup with 4-digit code ─────────
  static async verifyPickup(bookingId: string, driverId: string, code: string) {
    const { data: booking, error: readErr } = await supabaseAdmin
      .from('bookings')
      .select('*, rides:ride_id(driver_id)')
      .eq('id', bookingId)
      .single();

    if (readErr || !booking) throw new Error('Booking not found');
    if ((booking as any).rides?.driver_id !== driverId) {
      throw new Error('Only the ride driver can verify pickup');
    }
    if (booking.status !== 'accepted') {
      throw new Error(`Cannot verify pickup for ${booking.status} booking`);
    }
    if (booking.verification_code !== code) {
      throw new Error('Invalid pickup code');
    }

    const { data: updated, error: updErr } = await supabaseAdmin
      .from('bookings')
      .update({ status: 'started' })
      .eq('id', bookingId)
      .select('*')
      .single();
    if (updErr) throw new Error(`Failed to start booking: ${updErr.message}`);
    return updated;
  }

  // ── Rider's bookings ─────────────────────────────────
  static async getByRider(riderId: string) {
    const { data, error } = await supabaseAdmin
      .from('bookings')
      .select(`
        *,
        rides:ride_id(*,
          users:driver_id(full_name, profile_photo, reputation_score)
        )
      `)
      .eq('rider_id', riderId)
      .order('created_at', { ascending: false });

    if (error) throw new Error(`Failed to load bookings: ${error.message}`);
    return data ?? [];
  }

  // ── Driver's incoming requests across all their rides ──
  static async getByDriver(driverId: string) {
    // First fetch this driver's ride IDs
    const { data: rides, error: ridesErr } = await supabaseAdmin
      .from('rides')
      .select('id')
      .eq('driver_id', driverId);
    if (ridesErr) throw new Error(`Failed to load driver rides: ${ridesErr.message}`);
    const rideIds = (rides ?? []).map((r) => r.id);
    if (rideIds.length === 0) return [];

    const { data, error } = await supabaseAdmin
      .from('bookings')
      .select(`
        *,
        users:rider_id(full_name, profile_photo, reputation_score)
      `)
      .in('ride_id', rideIds)
      .order('created_at', { ascending: false });

    if (error) throw new Error(`Failed to load bookings: ${error.message}`);
    return (data ?? []).map((b: any) => ({
      ...b,
      rider_name: b.users?.full_name ?? null,
      rider_photo: b.users?.profile_photo ?? null,
      rider_rating: b.users?.reputation_score ?? null,
    }));
  }
}
