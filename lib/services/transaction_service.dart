import 'package:expense_tracker_app/services/api_service.dart';

import '../models/transaction_model.dart';

class TransactionService {
  static Future<List<TransactionModel>> getTransactions() async {
    final data = await ApiService.request(
      endpoint: '/transactions',
      method: 'GET',
    );

    return (data as List).map((e) => TransactionModel.fromJson(e)).toList();
  }

  static Future<TransactionModel> createTransaction(
    Map<String, dynamic> body,
  ) async {
    final data = await ApiService.request(
      endpoint: '/transactions',
      method: 'POST',
      body: body,
    );

    return TransactionModel.fromJson(data);
  }

  static Future<TransactionModel> updateTransaction(
    String id,
    Map<String, dynamic> body,
  ) async {
    final data = await ApiService.request(
      endpoint: '/transactions/$id',
      method: 'PATCH',
      body: body,
    );

    return TransactionModel.fromJson(data);
  }

  static Future<void> deleteTransaction(String id) async {
    await ApiService.request(endpoint: '/transactions/$id', method: 'DELETE');
  }
}
