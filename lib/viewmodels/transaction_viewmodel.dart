import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionViewModel extends ChangeNotifier {
  final List<TransactionModel> _transactions = [];

  double get totalIncome {
    return _transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get balance => totalIncome - totalExpense;

  List<TransactionModel> get transactions => _transactions;

  List<TransactionModel> getTransactionsByDate(DateTime date) {
    return _transactions.where((tx) {
      final txDate = tx.date; // đảm bảo model có field date

      return txDate.year == date.year &&
          txDate.month == date.month &&
          txDate.day == date.day;
    }).toList();
  }

  bool isLoading = false;
  String? error;

  /// GET ALL
  Future<void> fetchTransactions() async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await TransactionService.getTransactions();
      _transactions.clear();
      _transactions.addAll(data);
      error = null;
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  /// CREATE
  Future<bool> addTransaction(TransactionModel transaction) async {
    isLoading = true;
    notifyListeners();

    try {
      final newItem = await TransactionService.createTransaction(
        transaction.toJson(),
      );

      _transactions.insert(0, newItem);
      error = null;

      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // UPDATE
  Future<bool> updateTransaction(
    String id,
    TransactionModel transaction,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      final updated = await TransactionService.updateTransaction(
        id,
        transaction.toJson(),
      );

      final index = _transactions.indexWhere((e) => e.id == id);
      if (index != -1) {
        _transactions[index] = updated;
      }

      error = null;
      isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// DELETE
  Future<bool> deleteTransaction(String id) async {
    try {
      await TransactionService.deleteTransaction(id);

      _transactions.removeWhere((e) => e.id == id);
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
