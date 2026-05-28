import '../models/transaction_model.dart';
import 'api_service.dart';

/// Handles wallet operations: balance, deposits, withdrawals, transaction history.
class WalletService {
  final ApiService _api = ApiService();

  // ── Get wallet balance ─────────────────────────────
  Future<double> getBalance() async {
    final response = await _api.get('/wallet/balance');
    return (response['balance'] as num).toDouble();
  }

  // ── Deposit via JazzCash / EasyPaisa ───────────────
  Future<Map<String, dynamic>> deposit(double amount, String provider) async {
    return await _api.post('/wallet/deposit', body: {
      'amount': amount,
      'provider': provider, // 'jazzcash' | 'easypaisa'
    });
  }

  // ── Withdraw to bank account ───────────────────────
  Future<Map<String, dynamic>> withdraw(double amount, String bankAccount) async {
    return await _api.post('/wallet/withdraw', body: {
      'amount': amount,
      'bank_account': bankAccount,
    });
  }

  // ── Transaction history ────────────────────────────
  Future<List<TransactionModel>> getTransactions({int page = 1, int limit = 20}) async {
    final response = await _api.get('/wallet/transactions?page=$page&limit=$limit');
    final list = response['transactions'] as List<dynamic>;
    return list.map((t) => TransactionModel.fromJson(t as Map<String, dynamic>)).toList();
  }

  // ── Monthly savings report ─────────────────────────
  Future<Map<String, dynamic>> getMonthlySavings() async {
    return await _api.get('/wallet/savings-report');
  }
}
