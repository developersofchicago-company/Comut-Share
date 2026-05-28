import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/custom_button.dart';

class CnicUploadScreen extends StatefulWidget {
  const CnicUploadScreen({super.key});

  @override
  State<CnicUploadScreen> createState() => _CnicUploadScreenState();
}

class _CnicUploadScreenState extends State<CnicUploadScreen> {
  bool _hasFront = false;
  bool _hasBack = false;
  bool _isLoading = false;

  Future<void> _pickFrontImage() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulated camera/gallery pick
    setState(() {
      _isLoading = false;
      _hasFront = true;
    });
  }

  Future<void> _pickBackImage() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _isLoading = false;
      _hasBack = true;
    });
  }

  Future<void> _submitVerification() async {
    setState(() => _isLoading = true);
    // Simulated upload to Supabase storage + CNIC API
    await Future.delayed(const Duration(seconds: 1.5));
    setState(() => _isLoading = false);

    if (mounted) {
      // Direct user to home dashboard
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Identity Verification'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'CNIC Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your original CNIC front and back. Identity check is processed automatically within 4 hours.',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 32),

              // CNIC Front Upload Box
              GestureDetector(
                onTap: _pickFrontImage,
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hasFront ? AppColors.primary : AppColors.border,
                      width: _hasFront ? 1.5 : 1,
                    ),
                  ),
                  child: _hasFront
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 40),
                            SizedBox(height: 12),
                            Text('CNIC Front Captured Successfully', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 4),
                            Text('Tap to replace photo', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, color: AppColors.textSecondary, size: 40),
                            SizedBox(height: 12),
                            Text('Take Photo of CNIC Front', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 4),
                            Text('Make sure all details are readable', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // CNIC Back Upload Box
              GestureDetector(
                onTap: _pickBackImage,
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _hasBack ? AppColors.primary : AppColors.border,
                      width: _hasBack ? 1.5 : 1,
                    ),
                  ),
                  child: _hasBack
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 40),
                            SizedBox(height: 12),
                            Text('CNIC Back Captured Successfully', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 4),
                            Text('Tap to replace photo', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, color: AppColors.textSecondary, size: 40),
                            SizedBox(height: 12),
                            Text('Take Photo of CNIC Back', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 4),
                            Text('Make sure all details are readable', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                ),
              ),
              const Spacer(),

              // Warning or trust label
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your data is securely stored and is only used to verify your real identity to safeguard the community.',
                      style: TextStyle(fontSize: 11, color: AppColors.textMuted, height: 1.4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              CustomButton(
                label: 'Submit Identity Documents',
                onPressed: _submitVerification,
                isLoading: _isLoading,
                enabled: _hasFront && _hasBack,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
