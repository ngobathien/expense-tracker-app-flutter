import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/ai_chatbot_view_model.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng bộ nhớ khi đóng màn hình
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trợ lý tài chính AI"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AiChatbotViewModel>(
              builder: (context, vm, _) {
                return ListView.builder(
                  reverse: true, // Hiển thị tin nhắn mới nhất dưới cùng
                  padding: const EdgeInsets.all(15),
                  itemCount: vm.messages.length,
                  itemBuilder: (context, index) {
                    final msg = vm.messages[index];
                    return _buildChatBubble(msg);
                  },
                );
              },
            ),
          ),
          // Hiển thị thanh tiến trình khi AI đang trả lời
          if (context.watch<AiChatbotViewModel>().isLoading)
            const LinearProgressIndicator(color: Color(0xFFFF7B00)),
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildChatBubble(dynamic msg) {
    bool isUser = msg.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFFFF7B00) : Colors.grey[200],
          borderRadius: BorderRadius.circular(15).copyWith(
            bottomRight: isUser ? Radius.zero : const Radius.circular(15),
            bottomLeft: isUser ? const Radius.circular(15) : Radius.zero,
          ),
        ),
        child: Text(
          msg.text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final vm = Provider.of<AiChatbotViewModel>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Hỏi AI về chi tiêu...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[100],
                filled: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: (val) => _send(vm),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFFFF7B00),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => _send(vm),
            ),
          ),
        ],
      ),
    );
  }

  void _send(AiChatbotViewModel vm) {
    if (_controller.text.trim().isNotEmpty) {
      vm.sendMessage(_controller.text.trim());
      _controller.clear();
    }
  }
}
