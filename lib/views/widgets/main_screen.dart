import 'package:expense_tracker_app/views/category/category_list_screen.dart';
import 'package:expense_tracker_app/views/profile/settings_screen.dart';
import 'package:flutter/material.dart';

import '../calendar/calendar_screen.dart';
// import '../categories/category_list_screen.dart';
import '../home/dashboard_screen.dart';
import '../transactions/add_transaction_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CalendarScreen(),
    const CategoryListScreen(), // thêm
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddEditTransactionScreen(),
          ),
        ),
        backgroundColor: const Color(0xFFFF7B00),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.bar_chart,
                color: _selectedIndex == 0
                    ? const Color(0xFFFF7B00)
                    : Colors.grey,
              ),
              onPressed: () => setState(() => _selectedIndex = 0),
            ),
            IconButton(
              icon: Icon(
                Icons.calendar_month,
                color: _selectedIndex == 1
                    ? const Color(0xFFFF7B00)
                    : Colors.grey,
              ),
              onPressed: () => setState(() => _selectedIndex = 1),
            ),
            const SizedBox(width: 40), // Space for FAB
            IconButton(
              icon: Icon(
                Icons.grid_view,
                color: _selectedIndex == 2
                    ? const Color(0xFFFF7B00)
                    : Colors.grey,
              ),
              onPressed: () => setState(() => _selectedIndex = 2),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: _selectedIndex == 3
                    ? const Color(0xFFFF7B00)
                    : Colors.grey,
              ),
              onPressed: () => setState(() => _selectedIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}
