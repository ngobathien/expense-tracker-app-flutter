import 'package:expense_tracker_app/models/stats/monthly_stats_model.dart';
import 'package:flutter/material.dart';

import '../models/stats/category_stats_model.dart';
import '../models/stats/stats_model.dart';
import '../models/transaction_model.dart'; // import TransactionModel
import '../services/stats_service.dart';

class StatsViewModel extends ChangeNotifier {
  /// ================= STATE =================
  StatsModel? summary;
  List<MonthlyStatsModel> monthlyStats = [];
  MonthlyStatsModel? currentMonth;

  List<CategoryStatsModel> categoryStats = [];

  bool isLoading = false;
  String? error;

  /// ================= GETTERS =================
  double get balance => summary?.balance ?? 0;
  double get totalIncome => summary?.totalIncome ?? 0;
  double get totalExpense => summary?.totalExpense ?? 0;

  double get monthBalance => currentMonth?.balance ?? 0;
  double get monthIncome => currentMonth?.totalIncome ?? 0;
  double get monthExpense => currentMonth?.totalExpense ?? 0;

  List get incomeTransactions => currentMonth?.incomeTransactions ?? [];
  List get expenseTransactions => currentMonth?.expenseTransactions ?? [];

  /// ================= FUNCTIONS =================

  /// 🔥 summary (all time)
  Future<void> fetchSummary() async {
    _setLoading(true);
    try {
      summary = await StatsService.getSummary();
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  /// 🔥 monthly theo tháng
  Future<void> fetchMonthlyByDate(DateTime date) async {
    _setLoading(true);
    try {
      monthlyStats = await StatsService.getMonthly(date.month, date.year);
      currentMonth = monthlyStats.isNotEmpty ? monthlyStats.first : null;
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  /// 🔥 category (optional)
  Future<void> fetchCategory() async {
    _setLoading(true);
    try {
      categoryStats = await StatsService.getCategory();
    } catch (e) {
      error = e.toString();
    }
    _setLoading(false);
  }

  /// ================= HELPER =================
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}

/// ================= REALTIME HELPER =================
/// Sử dụng ChangeNotifier để update ngay UI khi thêm transaction
extension StatsRealtime on StatsViewModel {
  void addTransactionRealtime(TransactionModel transaction) {
    currentMonth ??= MonthlyStatsModel(
      month: transaction.date.month,
      incomeTransactions: [],
      expenseTransactions: [],
    );

    // Tạo Map đồng nhất với cấu trúc Dashboard đang chờ
    final txMap = {
      "id": transaction.id,
      "name": transaction.name,
      "amount": transaction.amount,
      "date": transaction.date
          .toIso8601String(), // Phải là String để DateTime.parse không lỗi
      "type": transaction.type, // BẮT BUỘC PHẢI CÓ DÒNG NÀY
    };

    if (transaction.isIncome) {
      currentMonth!.incomeTransactions.insert(0, txMap);
    } else {
      currentMonth!.expenseTransactions.insert(0, txMap);
    }

    // Cập nhật lại các con số tổng trên Card cam
    _updateTotals();
    notifyListeners();
  }

  // Viết thêm hàm này vào extension để tự tính toán lại tiền
  void _updateTotals() {
    if (currentMonth == null) return;
    currentMonth!.totalIncome = currentMonth!.incomeTransactions.fold(
      0.0,
      (sum, t) => sum + (t['amount'] ?? 0),
    );
    currentMonth!.totalExpense = currentMonth!.expenseTransactions.fold(
      0.0,
      (sum, t) => sum + (t['amount'] ?? 0),
    );
    currentMonth!.balance =
        currentMonth!.totalIncome - currentMonth!.totalExpense;
  }

  /// Cập nhật transaction trong currentMonth (realtime)
  void updateTransactionRealtime(TransactionModel transaction) {
    if (currentMonth == null) return;

    // Lấy danh sách đúng loại (income / expense)
    List txList = transaction.isIncome
        ? currentMonth!.incomeTransactions
        : currentMonth!.expenseTransactions;

    // Tìm transaction cần update
    final index = txList.indexWhere((t) => t['id'] == transaction.id);

    // Tạo map transaction chuẩn
    final txMap = {
      "id": transaction.id,
      "name": transaction.name,
      "amount": transaction.amount,
      "date": transaction.date.toIso8601String(),
      "type": transaction.type,
    };

    if (index != -1) {
      txList[index] = txMap; // cập nhật
    } else {
      txList.insert(0, txMap); // fallback nếu không tìm thấy
    }

    // Cập nhật lại tổng
    _updateTotals();
    notifyListeners();
  }

  void deleteTransactionRealtime(TransactionModel tx) {
    if (currentMonth == null) return;

    if (tx.isIncome) {
      currentMonth!.incomeTransactions.removeWhere(
        (e) => e['id'] == tx.id, // ✅ đúng key
      );
    } else {
      currentMonth!.expenseTransactions.removeWhere(
        (e) => e['id'] == tx.id, // ✅ đúng key
      );
    }

    /// 🔥 QUAN TRỌNG: tính lại total
    _updateTotals();

    notifyListeners();
  }
}
