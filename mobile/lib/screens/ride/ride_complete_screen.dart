import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/ride_service.dart';
import '../../widgets/custom_button.dart';

class RideCompleteScreen extends StatefulWidget {
  final String rideId;
  const RideCompleteScreen({super.key, required this.rideId});

  @override
  State<RideCompleteScreen> createState() => _RideCompleteScreenState();
}

class _RideCompleteScreenState extends State<RideCompleteScreen> {
  final _rideService = RideService();
  final _commentController = TextEditingController();
  int _stars = 5;
  bool _isSubmitting = false;
  String? _toUserId; // resolved from ride detail

  @override
  void initState() {
    super.initState();
    _resolveCounterparty();
  }

  Future<void> _resolveCounterparty() async {
    try {
      final ride = await _rideService.getRide(widget.rideId);
      if (!mounted) return;
      setState(() => _toUserId = ride.driverId);
    } catch (_) {
      // Non-blocking — user can still skip rating
    }
  }

  Future<void> _submit() async {
    if (_toUserId == null) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
      return;
    }
    setState(() => _isSubmitting = true);
    try {
      await _rideService.rateUser(
        widget.rideId,
        _toUserId!,
        _stars,
        comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rating failed: ${e.toString()}'), backgroundColor: Colors.red.shade700),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: AppColors.primary, size: 48),
              ),
              const SizedBox(height: 24),
              const Text('Commute Completed!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Text(
                'Payment has been split via wallet escrow.\nFuel-saver report will arrive in your inbox.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text('Rate your commute driver', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starNum = index + 1;
                  return IconButton(
                    icon: Icon(
                      starNum <= _stars ? Icons.star : Icons.star_border,
                      color: AppColors.primary,
                      size: 36,
                    ),
                    onPressed: () => setState(() => _stars = starNum),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _commentController,
                maxLines: 2,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Comment (optional)',
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                label: 'Submit Rating',
                isLoading: _isSubmitting,
                onPressed: _submit,
              ),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false),
                child: const Text('Skip', style: TextStyle(color: AppColors.textMuted)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
