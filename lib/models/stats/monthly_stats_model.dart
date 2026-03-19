class MonthlyStatsModel {
  int month;
  double totalIncome;
  double totalExpense;
  double balance;

  List<dynamic> incomeTransactions;
  List<dynamic> expenseTransactions;

  MonthlyStatsModel({
    required this.month,
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.balance = 0,
    List<dynamic>? incomeTransactions,
    List<dynamic>? expenseTransactions,
  }) : incomeTransactions = incomeTransactions ?? [],
       expenseTransactions = expenseTransactions ?? [];

  factory MonthlyStatsModel.fromJson(Map<String, dynamic> json) {
    return MonthlyStatsModel(
      month: json['month'] ?? 0,
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      incomeTransactions: (json['incomeTransactions'] ?? [])
          .map(
            (e) =>
                Map<String, dynamic>.from(e)
                  ..putIfAbsent('type', () => 'income'),
          )
          .toList(),
      expenseTransactions: (json['expenseTransactions'] ?? [])
          .map(
            (e) =>
                Map<String, dynamic>.from(e)
                  ..putIfAbsent('type', () => 'expense'),
          )
          .toList(),
    );
  }
}
