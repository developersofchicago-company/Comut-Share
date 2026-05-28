import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/custom_button.dart';

class RideDetailScreen extends StatelessWidget {
  final String rideId;

  const RideDetailScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ride Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        radius: 28,
                        child: const Text('BI', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bilal Imran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                          SizedBox(height: 4),
                          Text('Habib Bank Ltd', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text('Route', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text('DHA Phase 6 ➔ Shahrah-e-Faisal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text('Departure', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text('08:30 AM', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text('Seat Price', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text('Rs. 210', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomButton(
              label: 'Request Seat',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.activeRide, arguments: 'ride-123');
              },
            ),
          ],
        ),
      ),
    );
  }
}
