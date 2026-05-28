import 'package:flutter/material.dart';
import '../../config/theme.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: const Center(
        child: Text('Edit Profile details will appear here.'),
      ),
    );
  }
}
