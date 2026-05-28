import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({super.key});

  @override
  State<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _linkSent = false;
  bool _isLoading = false;

  // Blocklist of personal email providers — only corporate domains allowed
  static const _personalDomains = [
    '@gmail.com', '@yahoo.com', '@hotmail.com', '@outlook.com',
    '@icloud.com', '@protonmail.com', '@aol.com', '@live.com',
  ];

  bool get _isValidEmail {
    final email = _emailController.text.trim().toLowerCase();
    if (!email.contains('@') || !email.contains('.')) return false;
    return !_personalDomains.any((d) => email.endsWith(d));
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _sendVerificationLink() async {
    if (!_isValidEmail) return;
    setState(() => _isLoading = true);

    try {
      await _authService.updateCorporateEmail(_emailController.text.trim());
      if (!mounted) return;
      setState(() => _linkSent = true);
    } catch (e) {
      _showError('Could not send link: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _checkVerification() async {
    setState(() => _isLoading = true);

    try {
      final verified = await _authService.checkEmailVerified();
      if (!mounted) return;
      if (!verified) {
        _showError('Email not verified yet. Please click the link in your inbox.');
        return;
      }
      Navigator.pushReplacementNamed(context, AppRoutes.profileSetup);
    } catch (e) {
      _showError('Verification check failed: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Text(
                'Corporate Email',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your company email to verify your employment. Personal emails (Gmail, Yahoo) are not accepted.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 40),

              if (!_linkSent) ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'name@company.com',
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                    suffixIcon: _isValidEmail
                        ? const Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary.withValues(alpha: 0.08),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'We accept company domains only. A verification link will be sent to confirm your employment.',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.primary.withValues(alpha: 0.1),
                        ),
                        child: const Icon(Icons.mark_email_read_rounded, color: AppColors.primary, size: 32),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Verification Link Sent!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Check ${_emailController.text} and click the verification link.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: _sendVerificationLink,
                        child: const Text('Resend Link', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ],

              const Spacer(),

              CustomButton(
                label: _linkSent ? 'I\'ve Verified — Continue' : 'Send Verification Link',
                onPressed: _linkSent ? _checkVerification : _sendVerificationLink,
                isLoading: _isLoading,
                enabled: _linkSent || _isValidEmail,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
