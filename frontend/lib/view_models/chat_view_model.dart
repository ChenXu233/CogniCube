import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/chat.dart';

class ChatViewModel extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isSendButtonEnabled = false;
  bool isLoadingMore = false;
  List<Message> messages = [];

  void updateSendButtonState(bool isEnabled) {
    isSendButtonEnabled = isEnabled;
    notifyListeners();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 添加用户消息
    messages.add(Message(text: text, type: MessageType.user));
    notifyListeners();
    scrollToBottom();

    // 添加加载状态
    messages.add(Message(text: '', type: MessageType.loading));
    notifyListeners();
    scrollToBottom();

    try {
      // 获取 AI 响应
      final aiResponse = await ApiService.getAIResponse(text);
      messages.removeLast(); // 移除加载状态
      messages.add(Message(text: aiResponse, type: MessageType.ai));
      notifyListeners();
      scrollToBottom();
    } catch (e) {
      messages.removeLast(); // 移除加载状态
      messages.add(Message(text: 'Error: $e', type: MessageType.ai));
      notifyListeners();
      scrollToBottom();
    }

    messageController.clear();
    updateSendButtonState(false); // 清空输入框后禁用发送按钮
  }

   @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose(); // 确保释放 ScrollController
    super.dispose();
  }
}