import 'package:expense_tracker_app/models/stats/monthly_stats_model.dart';
import 'package:expense_tracker_app/services/api_service.dart';

import '../models/stats/category_stats_model.dart';
import '../models/stats/stats_model.dart';

class StatsService {
  static Future<StatsModel> getSummary() async {
    final data = await ApiService.request(
      endpoint: '/stats/summary',
      method: 'GET',
    );

    return StatsModel.fromJson(data);
  }

  static Future<List<MonthlyStatsModel>> getMonthly(int month, int year) async {
    final data = await ApiService.request(
      endpoint: '/stats/monthly?month=$month&year=$year',
      method: 'GET',
    );

    return (data as List).map((e) => MonthlyStatsModel.fromJson(e)).toList();
  }

  static Future<List<CategoryStatsModel>> getCategory() async {
    final data = await ApiService.request(
      endpoint: '/stats/category',
      method: 'GET',
    );

    return (data as List).map((e) => CategoryStatsModel.fromJson(e)).toList();
  }
}
