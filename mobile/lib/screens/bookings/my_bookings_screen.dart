import 'package:flutter/material.dart';
import '../../config/theme.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: const Center(
        child: Text('Bookings list will appear here.'),
      ),
    );
  }
}
