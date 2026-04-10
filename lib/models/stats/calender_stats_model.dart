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

class DailyDetail {
  final String date;
  final double totalIncome;
  final double totalExpense;
  final List transactions;

  DailyDetail({
    required this.date,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactions,
  });

  factory DailyDetail.fromJson(Map<String, dynamic> json) {
    return DailyDetail(
      date: json['date'],
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      transactions: json['transactions'] ?? [],
    );
  }
}

class CalendarStatsModel {
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<CalendarDay> calendar;
  final List<DailyDetail> daily;

  CalendarStatsModel({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.calendar,
    required this.daily,
  });

  factory CalendarStatsModel.fromJson(Map<String, dynamic> json) {
    return CalendarStatsModel(
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      calendar: (json['calendar'] as List)
          .map((e) => CalendarDay.fromJson(e))
          .toList(),
      daily: (json['daily'] as List)
          .map((e) => DailyDetail.fromJson(e))
          .toList(),
    );
  }
}
