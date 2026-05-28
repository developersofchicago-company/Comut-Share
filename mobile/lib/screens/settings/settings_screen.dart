import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _supabase = Supabase.instance.client;

  bool _smokingAllowed = false;
  bool _musicAllowed = true;
  bool _womenOnly = false;
  String _departureWindow = '08:15 AM - 08:45 AM';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;
      final data = await _supabase
          .from('user_preferences')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (!mounted) return;
      setState(() {
        if (data != null) {
          _smokingAllowed = data['smoking_allowed'] as bool? ?? false;
          _musicAllowed = data['music_allowed'] as bool? ?? true;
          _womenOnly = data['women_only'] as bool? ?? false;
          _departureWindow = data['departure_window'] as String? ?? '08:15 AM - 08:45 AM';
        }
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _save() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await _supabase.from('user_preferences').upsert({
        'user_id': userId,
        'smoking_allowed': _smokingAllowed,
        'music_allowed': _musicAllowed,
        'women_only': _womenOnly,
        'departure_window': _departureWindow,
        'updated_at': DateTime.now().toIso8601String(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved'), backgroundColor: AppColors.primary),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: ${e.toString()}'), backgroundColor: Colors.red.shade700),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Settings')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionHeader('Ride Preferences'),
                SwitchListTile(
                  title: const Text('Smoking allowed', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Drivers/riders OK with smoking', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  value: _smokingAllowed,
                  onChanged: (v) async {
                    setState(() => _smokingAllowed = v);
                    await _save();
                  },
                  activeThumbColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: const Text('Music in car', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Music during ride is welcome', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  value: _musicAllowed,
                  onChanged: (v) async {
                    setState(() => _musicAllowed = v);
                    await _save();
                  },
                  activeThumbColor: AppColors.primary,
                ),
                SwitchListTile(
                  title: const Text('Women-only matching', style: TextStyle(color: Colors.white)),
                  subtitle: const Text('Only match with female drivers/riders', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                  value: _womenOnly,
                  onChanged: (v) async {
                    setState(() => _womenOnly = v);
                    await _save();
                  },
                  activeThumbColor: AppColors.primary,
                ),
                const SizedBox(height: 16),
                _sectionHeader('About'),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: AppColors.primary),
                  title: const Text('App Version', style: TextStyle(color: Colors.white)),
                  trailing: const Text('1.0.0', style: TextStyle(color: AppColors.textMuted)),
                ),
                ListTile(
                  leading: const Icon(Icons.mail_outline, color: AppColors.primary),
                  title: const Text('Contact Support', style: TextStyle(color: Colors.white)),
                  subtitle: Text(Constants.supportEmail, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ),
                ListTile(
                  leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
                  title: const Text('Support Phone', style: TextStyle(color: Colors.white)),
                  subtitle: Text(Constants.supportPhone, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                ),
              ],
            ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
      ),
    );
  }
}
