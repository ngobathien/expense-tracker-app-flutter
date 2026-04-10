class CalendarStatsModel {
  final Summary summary;
  final List<CalendarDay> calendar;
  final List<DailyTransaction> daily;

  CalendarStatsModel({
    required this.summary,
    required this.calendar,
    required this.daily,
  });

  factory CalendarStatsModel.fromJson(Map<String, dynamic> json) {
    return CalendarStatsModel(
      summary: Summary.fromJson(json['summary']),
      calendar: (json['calendar'] as List)
          .map((e) => CalendarDay.fromJson(e))
          .toList(),
      daily: (json['daily'] as List)
          .map((e) => DailyTransaction.fromJson(e))
          .toList(),
    );
  }
}

// ================= SUMMARY =================
class Summary {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  Summary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}

// ================= CALENDAR GRID =================
class CalendarDay {
  final String date;
  final double income;
  final double expense;

  CalendarDay({
    required this.date,
    required this.income,
    required this.expense,
  });

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      date: json['date'],
      income: (json['income'] ?? 0).toDouble(),
      expense: (json['expense'] ?? 0).toDouble(),
    );
  }
}

// ================= DAILY LIST =================
class DailyTransaction {
  final String date;
  final double totalIncome;
  final double totalExpense;
  final double total;
  final List<TransactionItem> transactions;

  DailyTransaction({
    required this.date,
    required this.totalIncome,
    required this.totalExpense,
    required this.total,
    required this.transactions,
  });

  factory DailyTransaction.fromJson(Map<String, dynamic> json) {
    return DailyTransaction(
      date: json['date'],
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      transactions: (json['transactions'] as List)
          .map((e) => TransactionItem.fromJson(e))
          .toList(),
    );
  }
}

class TransactionItem {
  final String name;
  final double amount;
  final String categoryName;

  TransactionItem({
    required this.name,
    required this.amount,
    required this.categoryName,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      name: json['name'],
      amount: (json['amount'] ?? 0).toDouble(),
      categoryName: json['categoryName'] ?? '',
    );
  }
}
