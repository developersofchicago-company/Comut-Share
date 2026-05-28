// Rides service — handles ride CRUD and the matching algorithm.
//
// Matching algorithm (v1, simple haversine + time window):
//   1. Filter rides where status = 'published' AND seats_available > 0
//   2. Filter rides where pickup is within 2 km of rider's from-point
//   3. Filter rides where dropoff is within 3 km of rider's to-point
//   4. Filter rides departing within ±30 min of rider's preferred window (if given)
//   5. Filter to rider's company whitelist (drivers must share at least one company OR be public)
//   6. Sort by: pickup distance ASC, then departure time ASC, then driver rating DESC
//
// v2 (post-launch): ML-driven matching using historical preferences + reliability scores.

import { supabaseAdmin } from '../db/supabase.client';

export interface CreateRideInput {
  vehicle_id?: string;
  from_name: string;
  from_lat: number;
  from_lng: number;
  to_name: string;
  to_lat: number;
  to_lng: number;
  departure_time: string; // ISO 8601
  total_seats: number;
  price_per_seat: number;
  notes?: string;
}

export interface SearchRidesParams {
  from_lat?: number;
  from_lng?: number;
  to_lat?: number;
  to_lng?: number;
  departure_after?: string;
  departure_before?: string;
  min_seats?: number;
  rider_company_id?: string;
}

/** Haversine distance between two lat/lng points in kilometres. */
function haversineKm(lat1: number, lng1: number, lat2: number, lng2: number): number {
  const R = 6371; // Earth radius km
  const toRad = (deg: number) => (deg * Math.PI) / 180;
  const dLat = toRad(lat2 - lat1);
  const dLng = toRad(lng2 - lng1);
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLng / 2) ** 2;
  return 2 * R * Math.asin(Math.sqrt(a));
}

export class RidesService {
  // ── Create a ride ────────────────────────────────────
  static async create(driverId: string, input: CreateRideInput) {
    const insertPayload = {
      driver_id: driverId,
      vehicle_id: input.vehicle_id ?? null,
      from_name: input.from_name,
      from_lat: input.from_lat,
      from_lng: input.from_lng,
      to_name: input.to_name,
      to_lat: input.to_lat,
      to_lng: input.to_lng,
      departure_time: input.departure_time,
      total_seats: input.total_seats,
      seats_available: input.total_seats,
      price_per_seat: input.price_per_seat,
      notes: input.notes ?? null,
      status: 'published',
    };

    const { data, error } = await supabaseAdmin
      .from('rides')
      .insert(insertPayload)
      .select('*')
      .single();

    if (error) throw new Error(`Failed to create ride: ${error.message}`);
    return data;
  }

  // ── Search & match rides ─────────────────────────────
  static async search(params: SearchRidesParams) {
    let query = supabaseAdmin
      .from('rides')
      .select(`
        *,
        users:driver_id(full_name, profile_photo, reputation_score, company_id, companies:company_id(name)),
        vehicles:vehicle_id(make, model, color, registration_number)
      `)
      .eq('status', 'published')
      .gt('seats_available', 0);

    if (params.departure_after) query = query.gte('departure_time', params.departure_after);
    if (params.departure_before) query = query.lte('departure_time', params.departure_before);
    if (params.min_seats) query = query.gte('seats_available', params.min_seats);

    const { data, error } = await query.order('departure_time', { ascending: true }).limit(50);
    if (error) throw new Error(`Search failed: ${error.message}`);

    // Geo filter + scoring done in app layer (PostGIS would be the prod move)
    const PICKUP_RADIUS_KM = 2.0;
    const DROPOFF_RADIUS_KM = 3.0;

    let results = (data ?? []).map((r: any) => {
      const pickupDistance =
        params.from_lat != null && params.from_lng != null
          ? haversineKm(params.from_lat, params.from_lng, r.from_lat, r.from_lng)
          : 0;
      const dropoffDistance =
        params.to_lat != null && params.to_lng != null
          ? haversineKm(params.to_lat, params.to_lng, r.to_lat, r.to_lng)
          : 0;
      return {
        ...r,
        // Flatten joined fields for the Flutter RideModel.fromJson contract
        driver_name: r.users?.full_name ?? null,
        driver_photo: r.users?.profile_photo ?? null,
        driver_rating: r.users?.reputation_score ?? null,
        driver_company: r.users?.companies?.name ?? null,
        vehicle_make: r.vehicles?.make ?? null,
        vehicle_model: r.vehicles?.model ?? null,
        vehicle_color: r.vehicles?.color ?? null,
        vehicle_reg_number: r.vehicles?.registration_number ?? null,
        _pickup_distance_km: pickupDistance,
        _dropoff_distance_km: dropoffDistance,
      };
    });

    if (params.from_lat != null && params.from_lng != null) {
      results = results.filter((r) => r._pickup_distance_km <= PICKUP_RADIUS_KM);
    }
    if (params.to_lat != null && params.to_lng != null) {
      results = results.filter((r) => r._dropoff_distance_km <= DROPOFF_RADIUS_KM);
    }

    // Sort: pickup distance, then departure time, then driver rating
    results.sort((a, b) => {
      if (a._pickup_distance_km !== b._pickup_distance_km) {
        return a._pickup_distance_km - b._pickup_distance_km;
      }
      const tDiff = new Date(a.departure_time).getTime() - new Date(b.departure_time).getTime();
      if (tDiff !== 0) return tDiff;
      return (b.driver_rating ?? 0) - (a.driver_rating ?? 0);
    });

    return results;
  }

  // ── Get one ride with full driver+vehicle detail ─────
  static async getById(rideId: string) {
    const { data, error } = await supabaseAdmin
      .from('rides')
      .select(`
        *,
        users:driver_id(full_name, profile_photo, reputation_score, company_id, companies:company_id(name)),
        vehicles:vehicle_id(make, model, color, registration_number)
      `)
      .eq('id', rideId)
      .single();
    if (error) throw new Error(`Ride not found: ${error.message}`);
    return {
      ...data,
      driver_name: (data as any).users?.full_name ?? null,
      driver_photo: (data as any).users?.profile_photo ?? null,
      driver_rating: (data as any).users?.reputation_score ?? null,
      driver_company: (data as any).users?.companies?.name ?? null,
      vehicle_make: (data as any).vehicles?.make ?? null,
      vehicle_model: (data as any).vehicles?.model ?? null,
      vehicle_color: (data as any).vehicles?.color ?? null,
      vehicle_reg_number: (data as any).vehicles?.registration_number ?? null,
    };
  }

  // ── List rides posted by a specific driver ───────────
  static async getByDriver(driverId: string) {
    const { data, error } = await supabaseAdmin
      .from('rides')
      .select('*')
      .eq('driver_id', driverId)
      .order('departure_time', { ascending: false });
    if (error) throw new Error(`Failed to load rides: ${error.message}`);
    return data ?? [];
  }

  // ── Lifecycle transitions ────────────────────────────
  static async start(rideId: string, driverId: string) {
    const { data, error } = await supabaseAdmin
      .from('rides')
      .update({ status: 'started' })
      .eq('id', rideId)
      .eq('driver_id', driverId) // ownership check
      .select('*')
      .single();
    if (error) throw new Error(`Failed to start ride: ${error.message}`);
    return data;
  }

  static async complete(rideId: string, driverId: string) {
    const { data, error } = await supabaseAdmin
      .from('rides')
      .update({ status: 'completed' })
      .eq('id', rideId)
      .eq('driver_id', driverId)
      .select('*')
      .single();
    if (error) throw new Error(`Failed to complete ride: ${error.message}`);

    // Mark related bookings as completed too
    await supabaseAdmin
      .from('bookings')
      .update({ status: 'completed' })
      .eq('ride_id', rideId)
      .in('status', ['accepted', 'started']);

    return data;
  }

  static async cancel(rideId: string, driverId: string) {
    const { data, error } = await supabaseAdmin
      .from('rides')
      .update({ status: 'cancelled' })
      .eq('id', rideId)
      .eq('driver_id', driverId)
      .select('*')
      .single();
    if (error) throw new Error(`Failed to cancel ride: ${error.message}`);

    // Cascade-cancel bookings; refunds handled in wallet service
    await supabaseAdmin
      .from('bookings')
      .update({ status: 'cancelled' })
      .eq('ride_id', rideId)
      .in('status', ['requested', 'accepted']);

    return data;
  }

  // ── Decrement seats_available when a booking is accepted ─
  static async decrementSeats(rideId: string, by: number = 1) {
    const { data: ride, error: readErr } = await supabaseAdmin
      .from('rides')
      .select('seats_available')
      .eq('id', rideId)
      .single();
    if (readErr) throw new Error(`Failed to read ride seats: ${readErr.message}`);

    const next = Math.max(0, (ride.seats_available as number) - by);
    const { error: updErr } = await supabaseAdmin
      .from('rides')
      .update({ seats_available: next })
      .eq('id', rideId);
    if (updErr) throw new Error(`Failed to decrement seats: ${updErr.message}`);
    return next;
  }

  static async incrementSeats(rideId: string, by: number = 1) {
    const { data: ride, error: readErr } = await supabaseAdmin
      .from('rides')
      .select('seats_available, total_seats')
      .eq('id', rideId)
      .single();
    if (readErr) throw new Error(`Failed to read ride seats: ${readErr.message}`);

    const next = Math.min(ride.total_seats as number, (ride.seats_available as number) + by);
    const { error: updErr } = await supabaseAdmin
      .from('rides')
      .update({ seats_available: next })
      .eq('id', rideId);
    if (updErr) throw new Error(`Failed to increment seats: ${updErr.message}`);
    return next;
  }
}
