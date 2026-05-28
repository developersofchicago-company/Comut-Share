enum RideStatus { published, started, completed, cancelled }

class RideModel {
  final String id;
  final String driverId;
  final String? vehicleId;
  final String fromName;
  final double fromLat;
  final double fromLng;
  final String toName;
  final double toLat;
  final double toLng;
  final DateTime departureTime;
  final int seatsAvailable;
  final int totalSeats;
  final double pricePerSeat;
  final String? notes;
  final RideStatus status;
  final DateTime createdAt;

  // Joined fields (from API)
  final String? driverName;
  final String? driverPhoto;
  final double? driverRating;
  final String? driverCompany;
  final String? vehicleMake;
  final String? vehicleModel;
  final String? vehicleColor;
  final String? vehicleRegNumber;

  RideModel({
    required this.id,
    required this.driverId,
    this.vehicleId,
    required this.fromName,
    required this.fromLat,
    required this.fromLng,
    required this.toName,
    required this.toLat,
    required this.toLng,
    required this.departureTime,
    required this.seatsAvailable,
    required this.totalSeats,
    required this.pricePerSeat,
    this.notes,
    this.status = RideStatus.published,
    required this.createdAt,
    this.driverName,
    this.driverPhoto,
    this.driverRating,
    this.driverCompany,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleColor,
    this.vehicleRegNumber,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      id: json['id'] as String,
      driverId: json['driver_id'] as String,
      vehicleId: json['vehicle_id'] as String?,
      fromName: json['from_name'] as String,
      fromLat: (json['from_lat'] as num).toDouble(),
      fromLng: (json['from_lng'] as num).toDouble(),
      toName: json['to_name'] as String,
      toLat: (json['to_lat'] as num).toDouble(),
      toLng: (json['to_lng'] as num).toDouble(),
      departureTime: DateTime.parse(json['departure_time'] as String),
      seatsAvailable: json['seats_available'] as int,
      totalSeats: json['total_seats'] as int,
      pricePerSeat: (json['price_per_seat'] as num).toDouble(),
      notes: json['notes'] as String?,
      status: RideStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => RideStatus.published,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      driverName: json['driver_name'] as String?,
      driverPhoto: json['driver_photo'] as String?,
      driverRating: (json['driver_rating'] as num?)?.toDouble(),
      driverCompany: json['driver_company'] as String?,
      vehicleMake: json['vehicle_make'] as String?,
      vehicleModel: json['vehicle_model'] as String?,
      vehicleColor: json['vehicle_color'] as String?,
      vehicleRegNumber: json['vehicle_reg_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driver_id': driverId,
      'vehicle_id': vehicleId,
      'from_name': fromName,
      'from_lat': fromLat,
      'from_lng': fromLng,
      'to_name': toName,
      'to_lat': toLat,
      'to_lng': toLng,
      'departure_time': departureTime.toIso8601String(),
      'seats_available': seatsAvailable,
      'total_seats': totalSeats,
      'price_per_seat': pricePerSeat,
      'notes': notes,
    };
  }

  String get vehicleDisplay {
    if (vehicleMake != null && vehicleModel != null) {
      return '$vehicleMake $vehicleModel${vehicleColor != null ? ' ($vehicleColor)' : ''}';
    }
    return 'Vehicle not specified';
  }

  bool get hasAvailableSeats => seatsAvailable > 0;
  bool get isActive => status == RideStatus.started;
  bool get isCompleted => status == RideStatus.completed;
}
