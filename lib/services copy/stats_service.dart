import 'dart:convert';

import 'package:expense_tracker_app/models/stats/category_stats_model.dart';
import 'package:expense_tracker_app/models/stats/monthly_stats_model.dart';
import 'package:http/http.dart' as http;

import '../models/stats/stats_model.dart';

class StatsService {
  static const String baseUrl = "http://10.0.2.2:3000/api/v1/stats";

  /// 🔥 SUMMARY (dashboard)
  static Future<StatsModel> getSummary(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/summary'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load summary');
    }

    final data = jsonDecode(res.body);
    return StatsModel.fromJson(data);
  }

  /// 📊 MONTHLY
  static Future<List<MonthlyStatsModel>> getMonthly(
    String token,
    int month,
    int year,
  ) async {
    final res = await http.get(
      Uri.parse('$baseUrl/monthly?month=$month&year=$year'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final List data = jsonDecode(res.body);
    return data.map((e) => MonthlyStatsModel.fromJson(e)).toList();
  }

  /// 🧠 CATEGORY
  static Future<List<CategoryStatsModel>> getCategory(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/category'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200) {
      throw Exception('Failed to load category stats');
    }

    final List data = jsonDecode(res.body);
    return data.map((e) => CategoryStatsModel.fromJson(e)).toList();
  }
}
