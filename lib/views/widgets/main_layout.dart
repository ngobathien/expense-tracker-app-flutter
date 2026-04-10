// import 'package:flutter/material.dart';

// import '../router/app_routes.dart';

// class MainLayout extends StatelessWidget {
//   final Widget child; // Đây là nội dung của màn hình (Lịch, Thống kê, v.v.)

//   const MainLayout({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Hiển thị nội dung màn hình con
//       body: child,

//       // Nút Chatbot lơ lửng
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFFFF7B00), // Màu cam thương hiệu của bạn
//         onPressed: () {
//           // Khi bấm vào sẽ mở màn hình Chatbot
//           // Đảm bảo bạn đã định nghĩa AppRoutes.aiChat trong router
//           Navigator.pushNamed(context, AppRoutes.aiChat);
//         },
//         child: const Icon(Icons.psychology, color: Colors.white, size: 30),
//       ),
//     );
//   }
// }
