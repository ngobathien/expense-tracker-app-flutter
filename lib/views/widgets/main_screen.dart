import 'package:expense_tracker_app/views/category/category_list_screen.dart';
import 'package:expense_tracker_app/views/profile/settings_screen.dart';
import 'package:flutter/material.dart';

import '../calendar/calendar_screen.dart';
import '../chatbot/ai_chat_screen.dart';
import '../home/dashboard_screen.dart';
import '../transactions/add_transaction_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Tọa độ mặc định cho bong bóng AI nổi
  double _top = 100.0;
  double _left = 20.0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CalendarScreen(),
    const CategoryListScreen(),
    const SettingsScreen(),
  ];

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return "Tổng quan";
      case 1:
        return "Lịch giao dịch";
      case 2:
        return "Danh mục";
      case 3:
        return "Cài đặt";
      default:
        return "Expense Tracker";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_getAppBarTitle()), centerTitle: false),

      // Dùng Stack để đè bong bóng AI lên trên nội dung màn hình
      body: Stack(
        children: [
          _screens[_selectedIndex],

          // --- BONG BÓNG AI CÓ THỂ KÉO THẢ ---
          Positioned(
            top: _top,
            left: _left,
            child: Draggable(
              feedback: _buildAiBubble(isDragging: true),
              childWhenDragging: Container(),
              onDragEnd: (details) {
                setState(() {
                  // Điều chỉnh tọa độ để không bị lệch do AppBar và StatusBar
                  _top =
                      details.offset.dy -
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top;
                  _left = details.offset.dx;
                });
              },
              child: _buildAiBubble(),
            ),
          ),
        ],
      ),

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
            _buildNavItem(Icons.bar_chart, 0),
            _buildNavItem(Icons.calendar_month, 1),
            const SizedBox(width: 40),
            _buildNavItem(Icons.grid_view, 2),
            _buildNavItem(Icons.settings, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        color: _selectedIndex == index ? const Color(0xFFFF7B00) : Colors.grey,
      ),
      onPressed: () => setState(() => _selectedIndex = index),
    );
  }

  Widget _buildAiBubble({bool isDragging = false}) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          if (!isDragging) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AiChatScreen()),
            );
          }
        },
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFFFF7B00),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDragging ? 0.4 : 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome, // Icon AI hiện đại
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}
