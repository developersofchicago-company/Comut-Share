class Constants {
  // API
  static const String apiBaseUrl = 'http://10.0.2.2:5000/api'; // Android emulator localhost
  static const String webApiBaseUrl = 'http://localhost:5000/api';

  // Supabase
  static const String supabaseUrl = 'https://epkrmxatgqjbqzrmisvy.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVwa3JteGF0Z3FqYnF6cm1pc3Z5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk5MDk4ODEsImV4cCI6MjA5NTQ4NTg4MX0.uedi1kpSgUAiQHmScmJgutonHdzckHQNVVesInGG3LA';

  // Google Maps
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // Pricing Defaults (from proposal — OGRA-anchored)
  static const double defaultPetrolRate = 409.78;     // Rs. per litre (OGRA 16 May 2026)
  static const double defaultEfficiency = 6.0;         // km/L Karachi city traffic
  static const double driverMarginPerKm = 8.0;         // Rs. per km
  static const double platformCommission = 0.10;        // 10%
  static const int defaultSeats = 3;

  // Verification
  static const int otpLength = 6;
  static const int otpExpirySeconds = 120;
  static const int pickupCodeLength = 4;
  static const int cnicVerificationHours = 4;

  // Wallet
  static const double minWithdrawal = 1000.0;           // Rs.
  static const String withdrawalDay = 'Friday';

  // Ride Limits
  static const int maxSeats = 4;
  static const int minSeats = 1;
  static const double maxPriceAdjustment = 0.15;        // ±15%
  static const int driverAcceptTimeoutMinutes = 15;

  // Safety
  static const int maxReportsBeforeBlock = 3;
  static const int rideStreakForFreeCredit = 5;
  static const double referralBonusAmount = 200.0;       // Rs.

  // App Info
  static const String appName = 'ComutShare';
  static const String appTagline = 'Karachi\'s Corporate Carpool';
  static const String companyName = 'Developers of Chicago';
  static const String supportEmail = 'inquiry@developersofchicago.com';
  static const String supportPhone = '+92-325-9283582';
}
