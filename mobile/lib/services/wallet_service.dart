import '../models/transaction_model.dart';
import 'api_service.dart';

/// Wallet operations: balance, deposits, withdrawals, transaction history.
class WalletService {
  final ApiService _api = ApiService();

  Future<double> getBalance() async {
    final response = await _api.get('/wallet/balance');
    return (response['balance'] as num).toDouble();
  }

  /// Top up via JazzCash / EasyPaisa.
  /// [paymentReference] is the txn ID from the payment provider — the backend
  /// validates it before crediting the wallet.
  Future<double> topup({
    required double amount,
    required String paymentMethod,
    required String paymentReference,
  }) async {
    final response = await _api.post('/wallet/topup', body: {
      'amount': amount,
      'payment_method': paymentMethod, // 'jazzcash' | 'easypaisa'
      'payment_reference': paymentReference,
    });
    return (response['balance'] as num).toDouble();
  }

  /// Withdraw to bank account via 1LINK.
  Future<double> withdraw({
    required double amount,
    required String bankAccount,
    required String bankName,
  }) async {
    final response = await _api.post('/wallet/withdraw', body: {
      'amount': amount,
      'bank_account': bankAccount,
      'bank_name': bankName,
    });
    return (response['balance'] as num).toDouble();
  }

  Future<List<TransactionModel>> getTransactions({int limit = 50}) async {
    final response = await _api.get('/wallet/transactions?limit=$limit');
    final list = response['transactions'] as List<dynamic>;
    return list.map((t) => TransactionModel.fromJson(t as Map<String, dynamic>)).toList();
  }
}
