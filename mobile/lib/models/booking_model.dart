enum BookingStatus { requested, accepted, declined, started, completed, cancelled }

class BookingModel {
  final String id;
  final String rideId;
  final String riderId;
  final int seatsBooked;
  final BookingStatus status;
  final String verificationCode;
  final String? emergencyContact;
  final DateTime createdAt;

  // Joined fields
  final String? riderName;
  final String? riderPhoto;
  final double? riderRating;

  BookingModel({
    required this.id,
    required this.rideId,
    required this.riderId,
    this.seatsBooked = 1,
    this.status = BookingStatus.requested,
    required this.verificationCode,
    this.emergencyContact,
    required this.createdAt,
    this.riderName,
    this.riderPhoto,
    this.riderRating,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      rideId: json['ride_id'] as String,
      riderId: json['rider_id'] as String,
      seatsBooked: json['seats_booked'] as int? ?? 1,
      status: BookingStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => BookingStatus.requested,
      ),
      verificationCode: json['verification_code'] as String,
      emergencyContact: json['emergency_contact'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      riderName: json['rider_name'] as String?,
      riderPhoto: json['rider_photo'] as String?,
      riderRating: (json['rider_rating'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'rider_id': riderId,
      'seats_booked': seatsBooked,
      'emergency_contact': emergencyContact,
    };
  }

  bool get isPending => status == BookingStatus.requested;
  bool get isAccepted => status == BookingStatus.accepted;
  bool get isActive => status == BookingStatus.started;
  bool get isDone => status == BookingStatus.completed;
}
