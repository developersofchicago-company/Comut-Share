import '../models/ride_model.dart';
import '../models/booking_model.dart';
import 'api_service.dart';

/// Handles ride posting, searching, booking, and active ride management.
class RideService {
  final ApiService _api = ApiService();

  // ── Post a new ride (Driver) ─────────────────────────
  Future<RideModel> createRide(Map<String, dynamic> rideData) async {
    final response = await _api.post('/rides', body: rideData);
    return RideModel.fromJson(response['ride'] as Map<String, dynamic>);
  }

  // ── Search available rides (Rider) ───────────────────
  Future<List<RideModel>> searchRides({
    double? fromLat,
    double? fromLng,
    double? toLat,
    double? toLng,
    DateTime? departureAfter,
    DateTime? departureBefore,
    int? minSeats,
  }) async {
    final queryParams = <String, String>{};
    if (fromLat != null) queryParams['from_lat'] = fromLat.toString();
    if (fromLng != null) queryParams['from_lng'] = fromLng.toString();
    if (toLat != null) queryParams['to_lat'] = toLat.toString();
    if (toLng != null) queryParams['to_lng'] = toLng.toString();
    if (departureAfter != null) queryParams['departure_after'] = departureAfter.toIso8601String();
    if (departureBefore != null) queryParams['departure_before'] = departureBefore.toIso8601String();
    if (minSeats != null) queryParams['min_seats'] = minSeats.toString();

    final query = queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
    final response = await _api.get('/rides?$query');
    final rides = response['rides'] as List<dynamic>;
    return rides.map((r) => RideModel.fromJson(r as Map<String, dynamic>)).toList();
  }

  // ── Get ride detail ──────────────────────────────────
  Future<RideModel> getRide(String rideId) async {
    final response = await _api.get('/rides/$rideId');
    return RideModel.fromJson(response['ride'] as Map<String, dynamic>);
  }

  // ── Get driver's posted rides ────────────────────────
  Future<List<RideModel>> getMyRides() async {
    final response = await _api.get('/rides/mine');
    final rides = response['rides'] as List<dynamic>;
    return rides.map((r) => RideModel.fromJson(r as Map<String, dynamic>)).toList();
  }

  // ── Request a seat (Rider) ───────────────────────────
  Future<BookingModel> requestSeat(String rideId, {String? message, String? emergencyContact}) async {
    final response = await _api.post('/bookings', body: {
      'ride_id': rideId,
      'message': message,
      'emergency_contact': emergencyContact,
    });
    return BookingModel.fromJson(response['booking'] as Map<String, dynamic>);
  }

  // ── Accept/Decline booking request (Driver) ──────────
  Future<BookingModel> updateBookingStatus(String bookingId, String status) async {
    final response = await _api.put('/bookings/$bookingId', body: {'status': status});
    return BookingModel.fromJson(response['booking'] as Map<String, dynamic>);
  }

  // ── Get my bookings (as Rider) ───────────────────────
  Future<List<BookingModel>> getMyBookings() async {
    final response = await _api.get('/bookings/mine');
    final bookings = response['bookings'] as List<dynamic>;
    return bookings.map((b) => BookingModel.fromJson(b as Map<String, dynamic>)).toList();
  }

  // ── Start ride (Driver) ──────────────────────────────
  Future<void> startRide(String rideId) async {
    await _api.put('/rides/$rideId/start');
  }

  // ── Verify pickup code (Driver) ──────────────────────
  Future<void> verifyPickup(String bookingId, String code) async {
    await _api.post('/bookings/$bookingId/verify', body: {'code': code});
  }

  // ── Complete ride (Both parties) ─────────────────────
  Future<void> completeRide(String rideId) async {
    await _api.put('/rides/$rideId/complete');
  }

  // ── Cancel ride ──────────────────────────────────────
  Future<void> cancelRide(String rideId) async {
    await _api.put('/rides/$rideId/cancel');
  }

  // ── Rate a user after ride ───────────────────────────
  Future<void> rateUser(String rideId, String toUserId, int stars, {String? comment}) async {
    await _api.post('/ratings', body: {
      'ride_id': rideId,
      'to_user_id': toUserId,
      'stars': stars,
      'comment': comment,
    });
  }

  // ── Calculate pricing ────────────────────────────────
  Future<Map<String, dynamic>> calculatePricing({
    required double distanceKm,
    required double petrolRate,
    required int seats,
    double? efficiency,
  }) async {
    return await _api.post('/pricing/calculate', body: {
      'distanceKm': distanceKm,
      'petrolRate': petrolRate,
      'seats': seats,
      if (efficiency != null) 'efficiencyKmPerL': efficiency,
    });
  }
}
