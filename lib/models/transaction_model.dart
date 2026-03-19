/// Enum dùng trong UI (clean + tránh typo)
enum TransactionType { income, expense }

class TransactionModel {
  final String? id;
  final String name;
  final double amount;
  final String type; // 'income' | 'expense'
  final String? categoryType;
  final String? note;
  final DateTime date;
  final String? userId;
  final String? categoryId;

  TransactionModel({
    this.id,
    required this.name,
    required this.amount,
    required this.type,
    this.categoryType,
    this.note,
    required this.date,
    this.userId,
    this.categoryId,
  });

  /// ========================
  /// JSON → Object (SAFE)
  /// ========================
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    String? categoryId;
    final cat = json['categoryId'];
    if (cat != null) {
      if (cat is String)
        categoryId = cat;
      else if (cat is Map)
        categoryId = cat['_id']?.toString();
    }

    return TransactionModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      name: json['name']?.toString() ?? 'Giao dịch không tên',
      amount: _parseDouble(json['amount']),
      type: json['type']?.toString() ?? 'expense',
      categoryType: json['categoryType']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      date: _parseDate(json['date']),
      userId: json['userId']?.toString() ?? '',
      categoryId: categoryId,
    );
  }

  /// ========================
  /// Object → JSON
  /// ========================
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'name': name,
      'type': type,
      'note': note ?? '',
      'date': date.toIso8601String(),
      'categoryId': categoryId,
    };
  }

  /// ========================
  /// 🔥 HELPER
  /// ========================

  /// Convert String → Enum
  TransactionType get typeEnum {
    switch (type) {
      case 'expense':
        return TransactionType.expense;
      case 'income':
      default:
        return TransactionType.income;
    }
  }

  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';

  /// ========================
  /// 🛡️ SAFE PARSER
  /// ========================

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;

    if (value is num) return value.toDouble();

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}
