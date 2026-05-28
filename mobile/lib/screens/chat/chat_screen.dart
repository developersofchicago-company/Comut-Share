import 'package:flutter/material.dart';
import '../../config/theme.dart';

class ChatScreen extends StatelessWidget {
  final String rideId;

  const ChatScreen({super.key, required this.rideId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Commute Chat'),
      ),
      body: const Center(
        child: Text('Live ride chat messaging will appear here.'),
      ),
    );
  }
}
