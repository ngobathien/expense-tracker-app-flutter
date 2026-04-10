import '../services/api_service.dart';

class AiChatbotService {
  /// Gọi API chat với NestJS
  /// [message]: Câu hỏi của người dùng
  /// [userId]: ID của người dùng (nếu Backend yêu cầu trong Body)
  static Future<String> chatWithAI({
    required String message,
    required String userId,
  }) async {
    final data = await ApiService.request(
      endpoint: '/ai-chatbot/chat',
      method: 'POST',
      body: {'message': message, 'userId': userId},
    );

    // Vì Backend NestJS của bạn trả về response.text()
    // Nếu data là một chuỗi trực tiếp:
    // return data.toString();

    // Nếu NestJS trả về dạng { "reply": "..." } thì dùng:
    return data['reply'] ?? "";
  }
}
