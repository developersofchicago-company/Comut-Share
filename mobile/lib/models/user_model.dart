class UserModel {
  final String id;
  final String phone;
  final String? email;
  final String? fullName;
  final String? profilePhoto;
  final String? gender;
  final String? homeArea;
  final String? officeArea;
  final String? workingHours;
  final String? cnicFront;
  final String? cnicBack;
  final bool cnicVerified;
  final bool isDriver;
  final double reputationScore;
  final double walletBalance;
  final UserPreferences? preferences;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.phone,
    this.email,
    this.fullName,
    this.profilePhoto,
    this.gender,
    this.homeArea,
    this.officeArea,
    this.workingHours,
    this.cnicFront,
    this.cnicBack,
    this.cnicVerified = false,
    this.isDriver = false,
    this.reputationScore = 5.0,
    this.walletBalance = 0.0,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      gender: json['gender'] as String?,
      homeArea: json['home_area'] as String?,
      officeArea: json['office_area'] as String?,
      workingHours: json['working_hours'] as String?,
      cnicFront: json['cnic_front'] as String?,
      cnicBack: json['cnic_back'] as String?,
      cnicVerified: json['cnic_verified'] as bool? ?? false,
      isDriver: json['is_driver'] as bool? ?? false,
      reputationScore: (json['reputation_score'] as num?)?.toDouble() ?? 5.0,
      walletBalance: (json['wallet_balance'] as num?)?.toDouble() ?? 0.0,
      preferences: json['preferences'] != null
          ? UserPreferences.fromJson(json['preferences'])
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'full_name': fullName,
      'profile_photo': profilePhoto,
      'gender': gender,
      'home_area': homeArea,
      'office_area': officeArea,
      'working_hours': workingHours,
      'cnic_front': cnicFront,
      'cnic_back': cnicBack,
      'cnic_verified': cnicVerified,
      'is_driver': isDriver,
      'reputation_score': reputationScore,
      'wallet_balance': walletBalance,
      'preferences': preferences?.toJson(),
    };
  }

  String get initials {
    if (fullName == null || fullName!.isEmpty) return '??';
    final parts = fullName!.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName![0].toUpperCase();
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? profilePhoto,
    String? gender,
    String? homeArea,
    String? officeArea,
    String? workingHours,
    bool? isDriver,
    bool? cnicVerified,
    double? walletBalance,
    double? reputationScore,
    UserPreferences? preferences,
  }) {
    return UserModel(
      id: id,
      phone: phone,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      gender: gender ?? this.gender,
      homeArea: homeArea ?? this.homeArea,
      officeArea: officeArea ?? this.officeArea,
      workingHours: workingHours ?? this.workingHours,
      cnicFront: cnicFront,
      cnicBack: cnicBack,
      cnicVerified: cnicVerified ?? this.cnicVerified,
      isDriver: isDriver ?? this.isDriver,
      reputationScore: reputationScore ?? this.reputationScore,
      walletBalance: walletBalance ?? this.walletBalance,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

class UserPreferences {
  final String? departureWindow;
  final bool? smokingAllowed;
  final bool? musicAllowed;
  final bool? womenOnly;

  UserPreferences({
    this.departureWindow,
    this.smokingAllowed,
    this.musicAllowed,
    this.womenOnly,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      departureWindow: json['departure_window'] as String?,
      smokingAllowed: json['smoking_allowed'] as bool?,
      musicAllowed: json['music_allowed'] as bool?,
      womenOnly: json['women_only'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'departure_window': departureWindow,
      'smoking_allowed': smokingAllowed,
      'music_allowed': musicAllowed,
      'women_only': womenOnly,
    };
  }
}
