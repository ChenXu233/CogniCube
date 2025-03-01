import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../services/chat.dart';
import '../utils/constants.dart';

class ChatViewModel extends ChangeNotifier {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isSendButtonEnabled = false;
  bool isLoadingMore = false;
  List<Message> messages = [];

   Future<void> fetchMoreMessages() async {
    messages.clear();
    ChatApiService chatApiService = await ChatApiService.create();
    if (isLoadingMore) return;

    isLoadingMore = true;
    notifyListeners();

    final List<Message>  newMessages = [];
    
    if (Constants.useMockResponses){
      newMessages.addAll([
        Message(text: 'Hello, how can I assist you today?', type: "assistant"),
        Message(text: 'I am feeling a bit down today.', type: "user"),
      ]);
    }else{
      double timeEnd = DateTime.now().millisecondsSinceEpoch.toDouble()/1000;
      double timeStart = timeEnd - 60*60*24;
      newMessages.addAll(await chatApiService.getChatHistory(timeStart, timeEnd));
    }

    messages.insertAll(0, newMessages);

    isLoadingMore = false;
    notifyListeners();
  }

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
    ChatApiService chatApiService = await ChatApiService.create();
    if (text.trim().isEmpty) return;

    // 添加用户消息
    messages.add(Message(text: text, type: "user"));
    notifyListeners();
    scrollToBottom();

    // 添加加载状态
    messages.add(Message(text: '', type: "assistant"));
    notifyListeners();
    scrollToBottom();

    try {
      // 获取 AI 响应
      final aiResponse = await chatApiService.getAIResponse(text);
      print(aiResponse);
      messages.removeLast(); // 移除加载状态
      messages.add(Message(text: aiResponse, type: "user"));
      notifyListeners();
      scrollToBottom();
    } catch (e) {
      messages.removeLast(); // 移除加载状态
      messages.add(Message(text: 'Error: $e', type: "assistant"));
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