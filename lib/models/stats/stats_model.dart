class StatsModel {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  StatsModel({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });

  factory StatsModel.fromJson(Map<String, dynamic> json) {
    return StatsModel(
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}
