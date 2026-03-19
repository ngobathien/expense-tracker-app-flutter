import 'package:expense_tracker_app/models/transaction_model.dart';
import 'package:expense_tracker_app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/stats_viewmodel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime selectedDate = DateTime.now();
  String filterType = 'all'; // all | income | expense

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final vm = context.read<StatsViewModel>();
      vm.fetchSummary();
      vm.fetchMonthlyByDate(selectedDate);
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + delta);
    });

    context.read<StatsViewModel>().fetchMonthlyByDate(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatsViewModel>();

    final income = vm.monthIncome;
    final expense = vm.monthExpense;
    final balance = vm.monthBalance;

    // Tìm đoạn này trong hàm build và thay thế:
    final allTransactions = [
      ...vm.incomeTransactions.map(
        (e) =>
            Map<String, dynamic>.from(e)..putIfAbsent('type', () => 'income'),
      ),
      ...vm.expenseTransactions.map(
        (e) =>
            Map<String, dynamic>.from(e)..putIfAbsent('type', () => 'expense'),
      ),
    ];

    // Sắp xếp: Đảm bảo không chết App nếu trường date bị lỗi
    allTransactions.sort((a, b) {
      try {
        final dateA = DateTime.parse(
          a['date']?.toString() ?? DateTime.now().toIso8601String(),
        );
        final dateB = DateTime.parse(
          b['date']?.toString() ?? DateTime.now().toIso8601String(),
        );
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    final filtered = allTransactions.where((t) {
      if (filterType == 'all') return true;
      return t['type'] == filterType;
    }).toList();
    return Scaffold(
      backgroundColor: const Color(0xfff8f7f5),

      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Color(0xfff1f5f9))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.chevron_left, color: Colors.grey),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _changeMonth(-1),
                        child: const Icon(Icons.chevron_left),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MM/yyyy').format(selectedDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _changeMonth(1),
                        child: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),

                  const Icon(Icons.notifications_none, color: Colors.grey),
                ],
              ),
            ),
          ),

          /// ✅ BODY
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                /// 💰 CARD CAM
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orange, Color(0xffFF7B00)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tổng tháng",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${NumberFormat('#,###').format(balance)}đ",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "+${NumberFormat('#,###').format(income)}đ",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "-${NumberFormat('#,###').format(expense)}đ",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 📦 2 BOX
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            filterType = filterType == 'expense'
                                ? 'all'
                                : 'expense';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: filterType == 'expense'
                                ? Colors.red.shade50
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: filterType == 'expense'
                                  ? Colors.red.shade200
                                  : const Color(0xfff1f5f9),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Chi tiêu",
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "-${NumberFormat('#,###').format(expense)}đ",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            filterType = filterType == 'income'
                                ? 'all'
                                : 'income';
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: filterType == 'income'
                                ? Colors.green.shade50
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: filterType == 'income'
                                  ? Colors.green.shade200
                                  : const Color(0xfff1f5f9),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Thu nhập",
                                style: TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "+${NumberFormat('#,###').format(income)}đ",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// 📊 TỔNG
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: const Color(0xffFF7B00),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Tổng thu chi: ${NumberFormat('#,###').format(balance)}đ",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// 📜 LIST
                ...filtered.map((t) {
                  final type = t['type'] ?? 'expense';
                  final amount = (t['amount'] ?? 0);

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.addEditTransaction,
                        arguments: TransactionModel.fromJson(
                          Map<String, dynamic>.from(t),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.category),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t['name']?.toString() ?? 'Không tên',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    t['date'] != null
                                        ? DateTime.parse(t['date'])
                                        : DateTime.now(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text(
                            "${type == 'expense' ? '-' : '+'}${NumberFormat('#,###').format(amount)}đ",
                            style: TextStyle(
                              color: type == 'expense'
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                if (filtered.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: Text("Không có giao dịch")),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
