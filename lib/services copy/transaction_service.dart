import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/transaction_model.dart';

class TransactionService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1/transactions';

  /// GET ALL
  static Future<List<TransactionModel>> getTransactions(
    String accessToken,
  ) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => TransactionModel.fromJson(e)).toList();
    } else {
      throw Exception('Không tải được giao dịch');
    }
  }

  /// CREATE
  static Future<TransactionModel> createTransaction(
    Map<String, dynamic> body,
    String accessToken,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Không tạo được giao dịch");
    }
  }

  /// UPDATE
  static Future<TransactionModel> updateTransaction(
    String id,
    Map<String, dynamic> body,
    String accessToken,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Không cập nhật được giao dịch");
    }
  }

  /// DELETE
  static Future<void> deleteTransaction(String id, String accessToken) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Không xóa được giao dịch");
    }
  }
}
