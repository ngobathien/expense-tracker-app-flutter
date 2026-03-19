import 'package:expense_tracker_app/viewmodels/transaction_viewmodel.dart';
import 'package:expense_tracker_app/views/home/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TransactionViewModel>();
    final transactions = vm.getTransactionsByDate(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch giao dịch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildCalendarHeader(),
          _buildWeekDays(),
          _buildCalendarGrid(),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Giao dịch trong ngày',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${transactions.length} giao dịch',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Text('Không có giao dịch nào trong ngày này'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) =>
                        TransactionItem(transaction: transactions[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(
              () => _selectedDate = DateTime(
                _selectedDate.year,
                _selectedDate.month - 1,
                _selectedDate.day,
              ),
            ),
          ),
          Text(
            DateFormat('MMMM yyyy', 'vi_VN').format(_selectedDate),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(
              () => _selectedDate = DateTime(
                _selectedDate.year,
                _selectedDate.month + 1,
                _selectedDate.day,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays() {
    final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _selectedDate.year,
      _selectedDate.month + 1,
      0,
    );

    // Adjust for Monday start (T2)
    int offset = firstDayOfMonth.weekday - 1;
    if (offset < 0) offset = 6;

    final daysInMonth = lastDayOfMonth.day;
    final totalCells = offset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Container(
      height: rows * 50.0,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: rows * 7,
        itemBuilder: (context, index) {
          if (index < offset || index >= offset + daysInMonth) {
            return const SizedBox();
          }

          final day = index - offset + 1;
          final date = DateTime(_selectedDate.year, _selectedDate.month, day);
          final isSelected =
              date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;
          final isToday =
              date.day == DateTime.now().day &&
              date.month == DateTime.now().month &&
              date.year == DateTime.now().year;

          return GestureDetector(
            onTap: () => setState(() => _selectedDate = date),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF7B00)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: isToday && !isSelected
                    ? Border.all(color: const Color(0xFFFF7B00))
                    : null,
              ),
              child: Center(
                child: Text(
                  day.toString(),
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isToday ? const Color(0xFFFF7B00) : Colors.black),
                    fontWeight: isSelected || isToday
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
