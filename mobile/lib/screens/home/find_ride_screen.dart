import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../widgets/custom_button.dart';

class FindRideScreen extends StatefulWidget {
  const FindRideScreen({super.key});

  @override
  State<FindRideScreen> createState() => _FindRideScreenState();
}

class _FindRideScreenState extends State<FindRideScreen> {
  final _fromController = TextEditingController(text: 'Gulshan-e-Iqbal');
  final _toController = TextEditingController(text: 'I.I. Chundrigar Road');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Find a Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: 'Pickup Location',
                prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: 'Dropoff Location',
                prefixIcon: Icon(Icons.flag_outlined, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Matching Rides',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildRideCard(
                    driverName: 'Bilal Imran',
                    company: 'Habib Bank Ltd (HBL)',
                    route: 'Gulshan-e-Iqbal ➔ I.I. Chundrigar',
                    time: '08:30 AM',
                    price: 'Rs. 210',
                    seats: '3 seats left',
                  ),
                  _buildRideCard(
                    driverName: 'Ayesha Khan',
                    company: 'Systems Ltd',
                    route: 'Gulshan Block 4 ➔ Chundrigar Road',
                    time: '08:45 AM',
                    price: 'Rs. 195',
                    seats: '2 seats left',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRideCard({
    required String driverName,
    required String company,
    required String route,
    required String time,
    required String price,
    required String seats,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(driverName[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driverName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(company, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(seats, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(route, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(time, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
                Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.extrabold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Request Seat',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.rideDetail, arguments: 'ride-123');
              },
            ),
          ],
        ),
      ),
    );
  }
}
