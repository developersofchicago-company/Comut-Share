import 'package:flutter/material.dart';
import '../../config/theme.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wallet'),
      ),
      body: const Center(
        child: Text('Wallet top-up and transactions history will appear here.'),
      ),
    );
  }
}
