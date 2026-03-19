import 'package:expense_tracker_app/viewmodels/stats_viewmodel.dart';
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
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<StatsViewModel>().fetchCalendar(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StatsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch giao dịch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildCalendarHeader(),
                _buildWeekDays(),
                _buildCalendarGrid(vm),
                const Divider(),

                /// 🔥 TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Giao dịch trong ngày',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getSelectedTransactions(vm).length.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                /// 🔥 LIST
                Expanded(child: _buildTransactionList(vm)),
              ],
            ),
    );
  }

  // ================= HEADER =================
  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month - 1,
                );
              });
              context.read<StatsViewModel>().fetchCalendar(_selectedDate);
            },
          ),
          Text(
            DateFormat('MMMM yyyy', 'vi_VN').format(_selectedDate),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month + 1,
                );
              });
              context.read<StatsViewModel>().fetchCalendar(_selectedDate);
            },
          ),
        ],
      ),
    );
  }

  // ================= WEEK =================
  Widget _buildWeekDays() {
    final days = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
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

  // ================= GRID =================
  Widget _buildCalendarGrid(StatsViewModel vm) {
    final firstDay = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDay = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);

    int offset = firstDay.weekday - 1;
    final daysInMonth = lastDay.day;

    // 🔥 map nhanh
    final map = {for (var d in vm.calendarDays) d.date: d};

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: offset + daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        if (index < offset) return const SizedBox();

        final day = index - offset + 1;
        final date = DateTime(_selectedDate.year, _selectedDate.month, day);

        final key =
            "${date.year.toString().padLeft(4, '0')}-"
            "${date.month.toString().padLeft(2, '0')}-"
            "${date.day.toString().padLeft(2, '0')}";

        final dayData = map[key];

        final isSelected =
            date.day == _selectedDate.day && date.month == _selectedDate.month;

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),

                if (dayData != null) ...[
                  if (dayData.income > 0)
                    Text(
                      "+${dayData.income}",
                      style: const TextStyle(fontSize: 10, color: Colors.blue),
                    ),
                  if (dayData.expense > 0)
                    Text(
                      "-${dayData.expense}",
                      style: const TextStyle(fontSize: 10, color: Colors.red),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= GET SELECTED =================
  List _getSelectedTransactions(StatsViewModel vm) {
    final selected = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
    );

    try {
      final day = vm.dailyList.firstWhere((e) {
        final d = DateTime.parse(e.date);
        return d.year == selected.year &&
            d.month == selected.month &&
            d.day == selected.day;
      });

      return day.transactions ?? [];
    } catch (e) {
      return [];
    }
  }

  // ================= LIST =================
  Widget _buildTransactionList(StatsViewModel vm) {
    final list = _getSelectedTransactions(vm);

    if (list.isEmpty) {
      return const Center(child: Text('Không có giao dịch'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      itemBuilder: (_, i) {
        final tx = list[i];

        return ListTile(
          title: Text(tx.name),
          subtitle: Text(tx.categoryName),
          trailing: Text("${tx.amount}"),
        );
      },
    );
  }
}
