import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

/// Handles authentication flows directly via the Supabase client SDK:
/// Phone OTP, email updates, profile settings, and CNIC storage uploads.
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ── Send OTP to phone number ────────────────────────
  Future<void> sendOtp(String phone) async {
    // Format to international standard for Pakistan (+92) if not already done
    final formattedPhone = phone.startsWith('+') ? phone : '+92${phone.replaceFirst(RegExp(r'^0'), '')}';
    
    await _supabase.auth.signInWithOtp(
      phone: formattedPhone,
    );
  }

  // ── Verify OTP and get session ──────────────────────
  Future<AuthResponse> verifyOtp(String phone, String otp) async {
    final formattedPhone = phone.startsWith('+') ? phone : '+92${phone.replaceFirst(RegExp(r'^0'), '')}';
    
    final response = await _supabase.auth.verifyOTP(
      phone: formattedPhone,
      token: otp,
      type: OtpType.sms,
    );

    // If verification succeeded and user metadata doesn't exist in users table, insert a stub
    if (response.user != null) {
      final userId = response.user!.id;
      final existingUser = await _supabase.from('users').select().eq('id', userId).maybeSingle();
      
      if (existingUser == null) {
        await _supabase.from('users').insert({
          'id': userId,
          'phone': formattedPhone,
          'reputation_score': 5.00,
          'wallet_balance': 0.00,
        });
      }
    }
    
    return response;
  }

  // ── Send corporate email verification link ──────────
  Future<void> updateCorporateEmail(String email) async {
    // Update the authenticated user's email in Supabase auth
    await _supabase.auth.updateUser(
      UserAttributes(email: email),
    );
  }

  // ── Check email verification status ─────────────────
  Future<bool> checkEmailVerified() async {
    // Reload user data to get fresh session metadata
    final user = _supabase.auth.currentUser;
    if (user == null) return false;
    
    // Check if email has been verified via the link confirmation
    return user.emailConfirmedAt != null;
  }

  // ── Update profile details ──────────────────────────
  Future<UserModel> updateProfile({
    required String fullName,
    required String homeArea,
    required String officeArea,
    required String gender,
    required String workingHours,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('No authenticated user found');

    // Update fields in our customized users table
    final response = await _supabase
        .from('users')
        .update({
          'full_name': fullName,
          'home_area': homeArea,
          'office_area': officeArea,
          'gender': gender,
          'working_hours': workingHours,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId)
        .select()
        .single();

    return UserModel.fromJson(response);
  }

  // ── Upload CNIC images directly to Supabase Storage ──
  Future<Map<String, String>> uploadCnic(String frontFilePath, String backFilePath) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('No authenticated user found');

    final frontFile = File(frontFilePath);
    final backFile = File(backFilePath);

    final frontPath = 'cnics/$userId/front.jpg';
    final backPath = 'cnics/$userId/back.jpg';

    // Upload to 'identity-docs' storage bucket
    await _supabase.storage.from('identity-docs').upload(frontPath, frontFile, fileOptions: const FileOptions(upsert: true));
    await _supabase.storage.from('identity-docs').upload(backPath, backFile, fileOptions: const FileOptions(upsert: true));

    // Get public URLs
    final frontUrl = _supabase.storage.from('identity-docs').getPublicUrl(frontPath);
    final backUrl = _supabase.storage.from('identity-docs').getPublicUrl(backPath);

    // Save URLs to user database record
    await _supabase.from('users').update({
      'cnic_front': frontUrl,
      'cnic_back': backUrl,
      'cnic_verified': false, // requires moderator audit
    }).eq('id', userId);

    return {
      'front_url': frontUrl,
      'back_url': backUrl,
    };
  }

  // ── Get current user data ──────────────────────────
  Future<UserModel?> getCurrentUser() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return null;

    final data = await _supabase.from('users').select().eq('id', userId).maybeSingle();
    if (data == null) return null;
    
    return UserModel.fromJson(data);
  }

  // ── Logout ─────────────────────────────────────────
  Future<void> logout() async {
    await _supabase.auth.signOut();
  }
}
