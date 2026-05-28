class VehicleModel {
  final String id;
  final String userId;
  final String make;
  final String model;
  final int? year;
  final String? color;
  final String registrationNumber;
  final String? licensePhoto;
  final bool isVerified;
  final DateTime createdAt;

  VehicleModel({
    required this.id,
    required this.userId,
    required this.make,
    required this.model,
    this.year,
    this.color,
    required this.registrationNumber,
    this.licensePhoto,
    this.isVerified = false,
    required this.createdAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int?,
      color: json['color'] as String?,
      registrationNumber: json['registration_number'] as String,
      licensePhoto: json['license_photo'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'registration_number': registrationNumber,
      'license_photo': licensePhoto,
    };
  }

  String get displayName => '$make $model${color != null ? ' ($color)' : ''}';
  String get displayNameWithYear => '$make $model ${year ?? ''}${color != null ? ' - $color' : ''}'.trim();
}
