import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/custom_button.dart';

class PhoneOtpScreen extends StatefulWidget {
  const PhoneOtpScreen({super.key});

  @override
  State<PhoneOtpScreen> createState() => _PhoneOtpScreenState();
}

class _PhoneOtpScreenState extends State<PhoneOtpScreen> {
  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  bool _otpSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.length < 10) return;
    setState(() => _isLoading = true);

    // TODO: Call AuthService.sendOtp
    await Future.delayed(const Duration(seconds: 1)); // Simulated

    setState(() {
      _isLoading = false;
      _otpSent = true;
    });
    _otpFocusNodes[0].requestFocus();
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) return;
    setState(() => _isLoading = true);

    // TODO: Call AuthService.verifyOtp
    await Future.delayed(const Duration(seconds: 1)); // Simulated

    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.emailVerify);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: _otpSent
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => setState(() => _otpSent = false),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                _otpSent ? 'Verify OTP' : 'Enter Phone Number',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _otpSent
                    ? 'Enter the 6-digit code sent to +92${_phoneController.text}'
                    : 'We\'ll send you a one-time verification code via SMS',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 40),

              if (!_otpSent) ...[
                // Phone input
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                    color: AppColors.surfaceDim,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        decoration: BoxDecoration(
                          border: Border(right: BorderSide(color: AppColors.border)),
                        ),
                        child: const Text(
                          '🇵🇰 +92',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            hintText: '3XX XXXXXXX',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // OTP input boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 48,
                      height: 56,
                      child: TextField(
                        controller: _otpControllers[index],
                        focusNode: _otpFocusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          counterText: '',
                          filled: true,
                          fillColor: AppColors.surfaceDim,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _otpControllers[index].text.isNotEmpty
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2),
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            _otpFocusNodes[index + 1].requestFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            _otpFocusNodes[index - 1].requestFocus();
                          }
                          setState(() {});
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                // Resend
                Center(
                  child: TextButton(
                    onPressed: _sendOtp,
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],

              const Spacer(),

              // CTA Button
              CustomButton(
                label: _otpSent ? 'Verify & Continue' : 'Send OTP',
                onPressed: _otpSent ? _verifyOtp : _sendOtp,
                isLoading: _isLoading,
                enabled: _otpSent
                    ? _otpControllers.every((c) => c.text.isNotEmpty)
                    : _phoneController.text.length >= 10,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
