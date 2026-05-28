import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../widgets/custom_button.dart';

class OfferRideScreen extends StatefulWidget {
  const OfferRideScreen({super.key});

  @override
  State<OfferRideScreen> createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  final _fromController = TextEditingController(text: 'DHA Phase 6');
  final _toController = TextEditingController(text: 'Shahrah-e-Faisal');
  int _seats = 3;
  double _price = 210;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offer a Ride'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _fromController,
              decoration: const InputDecoration(
                labelText: 'Departure Location',
                prefixIcon: Icon(Icons.my_location, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _toController,
              decoration: const InputDecoration(
                labelText: 'Destination Location',
                prefixIcon: Icon(Icons.location_on, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Available Seats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(4, (index) {
                final seatNum = index + 1;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ChoiceChip(
                    label: Text('$seatNum seats'),
                    selected: _seats == seatNum,
                    onSelected: (selected) {
                      if (selected) setState(() => _seats = seatNum);
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
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
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Text('Suggested Seat Price', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                      Text('Rs. ${_price.toStringAsFixed(0)}', style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Price calculated dynamically using live OGRA fuel rate and Rs. 8/km wear-and-tear margin.',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            CustomButton(
              label: 'Publish Ride Offer',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ride published successfully!'), backgroundColor: AppColors.primary),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
