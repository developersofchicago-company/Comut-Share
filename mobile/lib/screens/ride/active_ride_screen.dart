import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/custom_button.dart';

class ActiveRideScreen extends StatelessWidget {
  final String rideId;

  const ActiveRideScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Active Commute'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.chat, arguments: rideId),
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
                  // Fake live map visual
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
                          Text('Live Commuter Tracking Map', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              label: 'Complete Commute',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.rideComplete, arguments: rideId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
