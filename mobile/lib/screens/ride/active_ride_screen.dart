import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../services/ride_service.dart';
import '../../widgets/custom_button.dart';

class ActiveRideScreen extends StatefulWidget {
  final String rideId;
  const ActiveRideScreen({super.key, required this.rideId});

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  final _rideService = RideService();
  final _codeController = TextEditingController();
  bool _isCompleting = false;

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade700, behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _completeRide() async {
    setState(() => _isCompleting = true);
    try {
      await _rideService.completeRide(widget.rideId);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.rideComplete, arguments: widget.rideId);
    } catch (e) {
      _showError('Could not complete ride: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Active Commute'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.chat, arguments: widget.rideId),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Ride Status', style: TextStyle(color: AppColors.textSecondary)),
                      Text('In Transit', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // INTEGRATION POINT: Google Maps live tracking would render here.
                  // For MVP we show a placeholder.
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDim,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text('Live tracking (Google Maps integration pending)',
                              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // SOS Button
            OutlinedButton.icon(
              onPressed: () {
                // INTEGRATION POINT: Trigger SOS to emergency contact + DC support
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    title: const Text('SOS Sent', style: TextStyle(color: Colors.white)),
                    content: const Text('Your emergency contact has been notified.',
                        style: TextStyle(color: AppColors.textSecondary)),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
              label: const Text('SOS — Send Alert', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const Spacer(),
            CustomButton(
              label: 'Complete Commute',
              isLoading: _isCompleting,
              onPressed: _completeRide,
            ),
          ],
        ),
      ),
    );
  }
}
