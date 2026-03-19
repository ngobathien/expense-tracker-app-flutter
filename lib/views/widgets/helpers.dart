import 'package:flutter/material.dart';

/// Hiển thị SnackBar
void showMessage(BuildContext context, String message, {bool success = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(success ? Icons.check_circle : Icons.error, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: success ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ),
  );
}

/// Hiển thị Dialog thông báo
Future<void> showMessageDialog(
  BuildContext context,
  String title,
  String message, {
  bool success = true,
}) {
  return showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: success ? Colors.green.shade50 : Colors.red.shade50,
      title: Row(
        children: [
          Icon(
            success ? Icons.check_circle : Icons.error,
            color: success ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Đóng"),
        ),
      ],
    ),
  );
}
