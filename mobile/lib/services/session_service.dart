// Session bridge — keeps the ApiService's bearer token in sync with the
// Supabase auth session, so HTTP calls to our Express backend authenticate
// as the same user that's signed into Supabase.

import 'package:supabase_flutter/supabase_flutter.dart';
import 'api_service.dart';

class SessionService {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  final ApiService _api = ApiService();

  /// Called once at app start. Loads existing session if any and sets the
  /// API token, then subscribes to future auth changes.
  void initialize() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      _api.setAuthToken(session.accessToken);
    }

    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        _api.setAuthToken(session.accessToken);
      } else {
        _api.clearAuthToken();
      }
    });
  }

  bool get isAuthenticated => _supabase.auth.currentSession != null;
  String? get currentUserId => _supabase.auth.currentUser?.id;
}
