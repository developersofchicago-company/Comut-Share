import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await _authService.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Sign Out?', style: TextStyle(color: Colors.white)),
        content: const Text('You can sign back in anytime with your phone number.',
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _user == null
                  ? const Center(child: Text('No profile loaded', style: TextStyle(color: Colors.white)))
                  : _buildBody(_user!),
    );
  }

  Widget _buildBody(UserModel user) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Avatar + name
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                backgroundImage: user.profilePhoto != null ? NetworkImage(user.profilePhoto!) : null,
                child: user.profilePhoto == null
                    ? Text(user.initials, style: const TextStyle(color: AppColors.primary, fontSize: 32, fontWeight: FontWeight.bold))
                    : null,
              ),
              const SizedBox(height: 16),
              Text(user.fullName ?? 'Unnamed', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(user.email ?? user.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 8),
              if (user.cnicVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, color: AppColors.primary, size: 14),
                      SizedBox(width: 4),
                      Text('CNIC Verified', style: TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('CNIC Pending Review',
                      style: TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Stats row
        Row(
          children: [
            Expanded(child: _statTile('Rating', '★ ${user.reputationScore.toStringAsFixed(1)}')),
            const SizedBox(width: 12),
            Expanded(child: _statTile('Wallet', 'Rs. ${user.walletBalance.toStringAsFixed(0)}')),
          ],
        ),
        const SizedBox(height: 24),

        // Info section
        _section('Account', [
          _infoTile(Icons.phone, 'Phone', user.phone),
          if (user.email != null) _infoTile(Icons.email, 'Email', user.email!),
          if (user.homeArea != null) _infoTile(Icons.home, 'Home', user.homeArea!),
          if (user.officeArea != null) _infoTile(Icons.business, 'Office', user.officeArea!),
          if (user.workingHours != null) _infoTile(Icons.access_time, 'Hours', user.workingHours!),
        ]),
        const SizedBox(height: 16),

        // Actions
        ListTile(
          leading: const Icon(Icons.edit, color: AppColors.primary),
          title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
          onTap: () async {
            await Navigator.pushNamed(context, AppRoutes.editProfile);
            _load();
          },
        ),
        ListTile(
          leading: const Icon(Icons.directions_car, color: AppColors.primary),
          title: const Text('My Rides', style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
          onTap: () => Navigator.pushNamed(context, AppRoutes.myBookings),
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          onTap: _logout,
        ),
      ],
    );
  }

  Widget _statTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title.toUpperCase(),
              style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textMuted, size: 20),
      title: Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
      subtitle: Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}
