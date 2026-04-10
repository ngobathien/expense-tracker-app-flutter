import 'package:expense_tracker_app/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';

import '../models/chat_message.model.dart';
import '../services/ai_chatbot_service.dart';

class AiChatbotViewModel extends ChangeNotifier {
  final AuthViewModel authVM;

  AiChatbotViewModel(this.authVM);

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userId = authVM.currentUser?.id;

    print("USER ID KHI CHAT: $userId"); // 👈 DEBUG

    /// ❌ Không có userId
    if (userId == null || userId.isEmpty) {
      _messages.insert(
        0,
        ChatMessage(
          text: "❌ Lỗi: Không tìm thấy userId",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      notifyListeners();
      return;
    }

    /// ✅ Thêm tin nhắn user
    _messages.insert(
      0,
      ChatMessage(text: text, isUser: true, timestamp: DateTime.now()),
    );

    _isLoading = true;
    notifyListeners();

    try {
      final response = await AiChatbotService.chatWithAI(
        message: text,
        userId: userId,
      );

      print("AI RESPONSE: $response"); // 👈 DEBUG
      print("AI RESPONSE LENGTH: ${response.length}");

      /// ✅ FIX: chống response rỗng
      final safeResponse = response.isEmpty ? "AI không có phản hồi" : response;

      /// ✅ Thêm tin nhắn AI
      _messages.insert(
        0,
        ChatMessage(
          text: safeResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      print("LỖI CHAT AI: $e");

      _messages.insert(
        0,
        ChatMessage(
          text: "Lỗi: ${e.toString()}",
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
