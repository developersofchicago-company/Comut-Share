import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/transaction_model.dart';
import '../../services/wallet_service.dart';
import '../../widgets/custom_button.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _walletService = WalletService();
  double _balance = 0;
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final balance = await _walletService.getBalance();
      final txns = await _walletService.getTransactions();
      if (!mounted) return;
      setState(() {
        _balance = balance;
        _transactions = txns;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showTopupDialog() async {
    final amountController = TextEditingController();
    String method = 'jazzcash';

    final amount = await showDialog<double>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocalState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Top Up Wallet', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Amount (Rs.)'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('JazzCash'),
                      selected: method == 'jazzcash',
                      onSelected: (s) => setLocalState(() => method = 'jazzcash'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('EasyPaisa'),
                      selected: method == 'easypaisa',
                      onSelected: (s) => setLocalState(() => method = 'easypaisa'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Payment gateway integration pending. Dev mode credits instantly.',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final value = double.tryParse(amountController.text);
                if (value != null && value > 0) Navigator.pop(ctx, value);
              },
              child: const Text('Top Up'),
            ),
          ],
        ),
      ),
    );

    if (amount == null) return;
    try {
      // INTEGRATION POINT: JazzCash/EasyPaisa redirect flow returns a payment reference
      // that we then POST to the backend for validation. For now we pass a stub.
      final newBalance = await _walletService.topup(
        amount: amount,
        paymentMethod: method,
        paymentReference: 'DEV-${DateTime.now().millisecondsSinceEpoch}',
      );
      if (!mounted) return;
      setState(() => _balance = newBalance);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Top-up failed: ${e.toString()}'), backgroundColor: Colors.red.shade700),
      );
    }
  }

  Future<void> _showWithdrawDialog() async {
    if (_balance < Constants.minWithdrawal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Minimum withdrawal is Rs. ${Constants.minWithdrawal.toStringAsFixed(0)}'),
        ),
      );
      return;
    }
    final amountController = TextEditingController();
    final accountController = TextEditingController();
    final bankController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Withdraw to Bank', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Amount (Rs.)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: accountController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Account Number'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bankController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Bank Name (HBL, UBL, Meezan, etc.)'),
              ),
              const SizedBox(height: 12),
              const Text(
                'Payouts process every Friday via 1LINK.',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final value = double.tryParse(amountController.text);
              if (value != null && value > 0 && accountController.text.isNotEmpty) {
                Navigator.pop(ctx, {
                  'amount': value,
                  'account': accountController.text,
                  'bank': bankController.text,
                });
              }
            },
            child: const Text('Request Payout'),
          ),
        ],
      ),
    );

    if (result == null) return;
    try {
      final newBalance = await _walletService.withdraw(
        amount: result['amount'] as double,
        bankAccount: result['account'] as String,
        bankName: result['bank'] as String,
      );
      if (!mounted) return;
      setState(() => _balance = newBalance);
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Withdraw failed: ${e.toString()}'), backgroundColor: Colors.red.shade700),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current Balance', style: TextStyle(color: AppColors.background, fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text(
                  'Rs. ${_balance.toStringAsFixed(0)}',
                  style: const TextStyle(color: AppColors.background, fontSize: 36, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: CustomButton(label: 'Top Up', onPressed: _showTopupDialog, icon: Icons.add)),
              const SizedBox(width: 12),
              Expanded(child: CustomButton(label: 'Withdraw', onPressed: _showWithdrawDialog, isSecondary: true, icon: Icons.outbox)),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Recent Transactions', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (_transactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text('No transactions yet.', style: TextStyle(color: AppColors.textSecondary)),
            )
          else
            ..._transactions.map(_buildTransactionTile),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(TransactionModel t) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: (t.isCredit ? AppColors.primary : Colors.red).withValues(alpha: 0.15),
          child: Icon(
            t.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: t.isCredit ? AppColors.primary : Colors.red,
            size: 18,
          ),
        ),
        title: Text(t.displayType, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${t.createdAt.day}/${t.createdAt.month}/${t.createdAt.year}',
          style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
        trailing: Text(
          t.formattedAmount,
          style: TextStyle(
            color: t.isCredit ? AppColors.primary : Colors.red.shade300,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
