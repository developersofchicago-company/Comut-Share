import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/custom_button.dart';

class RideCompleteScreen extends StatefulWidget {
  final String rideId;

  const RideCompleteScreen({super.key, required this.rideId});

  @override
  State<RideCompleteScreen> createState() => _RideCompleteScreenState();
}

class _RideCompleteScreenState extends State<RideCompleteScreen> {
  int _stars = 5;

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
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, color: AppColors.primary, size: 48),
              ),
              const SizedBox(height: 24),
              const Text(
                'Commute Completed!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Your payment has been split safely through wallet escrow.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text('Rate your commute driver', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
              const SizedBox(height: 48),
              CustomButton(
                label: 'Return to Home',
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
