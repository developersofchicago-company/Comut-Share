import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: const Center(
        child: Text('User Profile details will appear here.'),
      ),
    );
  }
}
