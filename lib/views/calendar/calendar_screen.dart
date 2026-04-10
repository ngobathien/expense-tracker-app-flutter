import 'package:expense_tracker_app/viewmodels/calendar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  // Format tiền tệ chuẩn VNĐ
  String formatMoney(num value) {
    return NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'đ',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarViewModel()..loadData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA), // Background xám nhạt như web
        appBar: AppBar(
          title: const Text(
            "Lịch giao dịch",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Consumer<CalendarViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading)
              return const Center(child: CircularProgressIndicator());
            if (vm.data == null)
              return const Center(child: Text("Không có dữ liệu"));

            return SingleChildScrollView(
              // Cho phép cuộn toàn trang
              child: Column(
                children: [
                  _buildHeader(vm),
                  _buildSummaryCard(vm),
                  _buildCalendarCard(vm),
                  if (vm.selectedDetail != null) _buildDetailCard(vm),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Header điều hướng tháng
  Widget _buildHeader(CalendarViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: vm.prevMonth,
            icon: const Icon(Icons.chevron_left, size: 30),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
              ],
            ),
            child: Text(
              "Tháng ${vm.month}/${vm.year}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: vm.nextMonth,
            icon: const Icon(Icons.chevron_right, size: 30),
          ),
        ],
      ),
    );
  }

  // Thẻ tổng quan (Summary Box)
  Widget _buildSummaryCard(CalendarViewModel vm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem("Thu", vm.data!.totalIncome, Colors.green),
          const VerticalDivider(thickness: 1),
          _buildSummaryItem("Chi", vm.data!.totalExpense, Colors.red),
          const VerticalDivider(thickness: 1),
          _buildSummaryItem("Dư", vm.data!.balance, Colors.blueGrey),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, num value, Color color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        const SizedBox(height: 4),
        Text(
          formatMoney(value),
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  // Card chứa Calendar Grid
  Widget _buildCalendarCard(CalendarViewModel vm) {
    int daysInMonth = DateTime(vm.year, vm.month + 1, 0).day;
    int firstDay = DateTime(vm.year, vm.month, 1).weekday;
    // Chuyển weekday của Dart (T2=1...CN=7) sang kiểu Web (T2=1...CN=7)
    int offset = firstDay - 1;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          // Header Thứ (T2, T3...)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
                .map(
                  (d) => Expanded(
                    child: Center(
                      child: Text(
                        d,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const Divider(),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 0.8, // Làm ô cao hơn chút để chứa text
            ),
            itemCount: daysInMonth + offset,
            itemBuilder: (context, index) {
              if (index < offset) return const SizedBox();

              int day = index - offset + 1;
              String dateKey =
                  "${vm.year}-${vm.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
              final dayData = vm.getDayData(dateKey);
              bool isSelected = vm.selectedDate == dateKey;
              bool isToday =
                  DateTime.now().day == day &&
                  DateTime.now().month == vm.month &&
                  DateTime.now().year == vm.year;

              return GestureDetector(
                onTap: () => vm.selectDate(dateKey),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.blue.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Colors.blue
                          : (isToday ? Colors.orange : Colors.transparent),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        "$day",
                        style: TextStyle(
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const Spacer(),
                      if (dayData.income > 0)
                        _dotAmount(dayData.income, Colors.green),
                      if (dayData.expense > 0)
                        _dotAmount(dayData.expense, Colors.red),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dotAmount(num val, Color color) {
    return Text(
      "● ${(val / 1000).round()}k",
      style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold),
    );
  }

  // Thẻ chi tiết phía dưới (như showCalendarDetail trong JS)
  Widget _buildDetailCard(CalendarViewModel vm) {
    final detail = vm.selectedDetail!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_note, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                "Chi tiết ${detail.date}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(),
          ...detail.transactions.map((t) {
            bool isIncome = t['type'] == 'INCOME';
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: isIncome
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                child: Icon(
                  isIncome ? Icons.add : Icons.remove,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
              title: Text(
                t['categoryName'] ?? 'Không tên',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(t['name'] ?? ''),
              trailing: Text(
                formatMoney(t['amount'] ?? 0),
                style: TextStyle(
                  color: isIncome ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
