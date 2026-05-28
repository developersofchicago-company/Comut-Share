import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/onboarding/phone_otp_screen.dart';
import '../screens/onboarding/email_verify_screen.dart';
import '../screens/onboarding/profile_setup_screen.dart';
import '../screens/onboarding/cnic_upload_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/find_ride_screen.dart';
import '../screens/home/offer_ride_screen.dart';
import '../screens/ride/ride_detail_screen.dart';
import '../screens/ride/active_ride_screen.dart';
import '../screens/ride/ride_complete_screen.dart';
import '../screens/bookings/my_bookings_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/settings/settings_screen.dart';

class AppRoutes {
  // Auth & Onboarding
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String phoneOtp = '/auth/phone-otp';
  static const String emailVerify = '/auth/email-verify';
  static const String profileSetup = '/auth/profile-setup';
  static const String cnicUpload = '/auth/cnic-upload';

  // Main App
  static const String home = '/home';
  static const String findRide = '/rides/find';
  static const String offerRide = '/rides/offer';
  static const String rideDetail = '/rides/detail';
  static const String activeRide = '/rides/active';
  static const String rideComplete = '/rides/complete';

  // Bookings & Wallet
  static const String myBookings = '/bookings';
  static const String wallet = '/wallet';

  // Profile
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';

  // Chat
  static const String chat = '/chat';

  // Settings
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fadeRoute(const SplashScreen(), settings);
      case welcome:
        return _slideRoute(const WelcomeScreen(), settings);
      case phoneOtp:
        return _slideRoute(const PhoneOtpScreen(), settings);
      case emailVerify:
        return _slideRoute(const EmailVerifyScreen(), settings);
      case profileSetup:
        return _slideRoute(const ProfileSetupScreen(), settings);
      case cnicUpload:
        return _slideRoute(const CnicUploadScreen(), settings);
      case home:
        return _fadeRoute(const HomeScreen(), settings);
      case findRide:
        return _slideRoute(const FindRideScreen(), settings);
      case offerRide:
        return _slideRoute(const OfferRideScreen(), settings);
      case rideDetail:
        final rideId = settings.arguments as String?;
        return _slideRoute(RideDetailScreen(rideId: rideId ?? ''), settings);
      case activeRide:
        final rideId = settings.arguments as String?;
        return _slideRoute(ActiveRideScreen(rideId: rideId ?? ''), settings);
      case rideComplete:
        final rideId = settings.arguments as String?;
        return _slideRoute(RideCompleteScreen(rideId: rideId ?? ''), settings);
      case myBookings:
        return _slideRoute(const MyBookingsScreen(), settings);
      case wallet:
        return _slideRoute(const WalletScreen(), settings);
      case profile:
        return _slideRoute(const ProfileScreen(), settings);
      case editProfile:
        return _slideRoute(const EditProfileScreen(), settings);
      case chat:
        final rideId = settings.arguments as String?;
        return _slideRoute(ChatScreen(rideId: rideId ?? ''), settings);
      case AppRoutes.settings:
        return _slideRoute(const SettingsScreen(), settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}
