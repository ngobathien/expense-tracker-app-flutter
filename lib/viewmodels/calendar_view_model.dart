import 'package:expense_tracker_app/models/stats/calender_stats_model.dart';
import 'package:flutter/material.dart';

import '../../services/stats_service.dart';

class CalendarViewModel extends ChangeNotifier {
  int month = DateTime.now().month;
  int year = DateTime.now().year;

  CalendarStatsModel? data;
  bool isLoading = false;
  String? selectedDate;

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      data = await StatsService.getCalendar(month, year);
    } catch (e) {
      data = null;
    }

    isLoading = false;
    notifyListeners();
  }

  void nextMonth() {
    if (month == 12) {
      month = 1;
      year++;
    } else {
      month++;
    }
    loadData();
  }

  void prevMonth() {
    if (month == 1) {
      month = 12;
      year--;
    } else {
      month--;
    }
    loadData();
  }

  void selectDate(String date) {
    selectedDate = date;
    notifyListeners();
  }

  CalendarDay getDayData(String date) {
    if (data == null) {
      return CalendarDay(date: date, income: 0, expense: 0);
    }

    return data!.calendar.firstWhere(
      (d) => d.date.contains(date),
      orElse: () => CalendarDay(date: date, income: 0, expense: 0),
    );
  }

  DailyDetail? get selectedDetail {
    if (data == null || selectedDate == null) return null;

    return data!.daily.firstWhere(
      (d) => d.date.contains(selectedDate!),
      orElse: () => DailyDetail(
        date: selectedDate!,
        totalIncome: 0,
        totalExpense: 0,
        transactions: [],
      ),
    );
  }
}
