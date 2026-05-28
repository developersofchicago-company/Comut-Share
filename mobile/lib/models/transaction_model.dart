enum TransactionType { deposit, withdraw, paymentDebit, paymentCredit, refund, bonus }
enum TransactionStatus { pending, completed, failed }

class TransactionModel {
  final String id;
  final String userId;
  final String? bookingId;
  final TransactionType type;
  final double amount;
  final TransactionStatus status;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    this.bookingId,
    required this.type,
    required this.amount,
    this.status = TransactionStatus.pending,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final typeMap = {
      'deposit': TransactionType.deposit,
      'withdraw': TransactionType.withdraw,
      'payment_debit': TransactionType.paymentDebit,
      'payment_credit': TransactionType.paymentCredit,
      'refund': TransactionType.refund,
      'bonus': TransactionType.bonus,
    };

    return TransactionModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookingId: json['booking_id'] as String?,
      type: typeMap[typeStr] ?? TransactionType.deposit,
      amount: (json['amount'] as num).toDouble(),
      status: TransactionStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => TransactionStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  bool get isCredit =>
      type == TransactionType.deposit ||
      type == TransactionType.paymentCredit ||
      type == TransactionType.refund ||
      type == TransactionType.bonus;

  String get displayType {
    switch (type) {
      case TransactionType.deposit:
        return 'Wallet Top-up';
      case TransactionType.withdraw:
        return 'Withdrawal';
      case TransactionType.paymentDebit:
        return 'Ride Payment';
      case TransactionType.paymentCredit:
        return 'Ride Earnings';
      case TransactionType.refund:
        return 'Refund';
      case TransactionType.bonus:
        return 'Bonus Credit';
    }
  }

  String get formattedAmount {
    final prefix = isCredit ? '+' : '-';
    return '$prefix Rs. ${amount.toStringAsFixed(0)}';
  }
}
