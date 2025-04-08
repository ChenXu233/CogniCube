// chat_view_model.dart
import 'package:flutter/material.dart';
import '../models/message_model.dart' as message_model;
import '../services/chat.dart';
import '../utils/constants.dart';

class ChatViewModel extends ChangeNotifier {
  int _nextMessageId = 1001;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isSendButtonEnabled = false;
  bool isLoadingMore = false;
  List<message_model.Message> messages = [];

  Future<void> fetchMoreMessages() async {
    if (isLoadingMore) return;
    isLoadingMore = true;
    notifyListeners();

    final newMessages =
        Constants.useMockResponses
            ? _generateMockMessages()
            : await _fetchApiMessages();

    messages = [...newMessages, ...messages];
    isLoadingMore = false;
    notifyListeners();
  }

  List<message_model.Message> _generateMockMessages() {
    return [
      message_model.Message(
        messages: [message_model.TextModel(text: '历史消息1：你好，有什么可以帮助你的？')],
        who: 'assistant',
        messageId: _nextMessageId++,
        timestamp: DateTime.now().millisecondsSinceEpoch.toDouble(),
      ),
    ];
  }

  Future<List<message_model.Message>> _fetchApiMessages() async {
    final timeEnd = DateTime.now().millisecondsSinceEpoch / 1000;
    final timeStart = timeEnd - 3600 * 24;
    return await ChatApiService.getChatHistory(timeStart, timeEnd);
  }

  void updateSendButtonState(String text) {
    isSendButtonEnabled = text.trim().isNotEmpty;
    notifyListeners();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = _createMessage(text, 'user');
    _addMessage(userMessage);

    try {
      final loadingMessage = _createMessage('正在加载...', 'loading', temp: true);
      _addMessage(loadingMessage);
      final response = await ChatApiService.getAIResponse(text);
      // print('收到回复: $response');
      final validReplyTo = userMessage.messageId;

      final aiMessage = _createMessage(
        response,
        'assistant',
        replyTo: validReplyTo,
      );
      _addMessage(aiMessage);
    } catch (e) {
      messages.removeLast();
      _addMessage(_createMessage('发生错误，请稍后再试:$e', 'assistant'));
    }
  }

  message_model.Message _createMessage(
    String text,
    String who, {
    int? replyTo,
    bool temp = false,
  }) {
    // 添加回复消息校验
    if (replyTo != null) {
      final exists = messages.any((m) => m.messageId == replyTo);
      if (!exists) replyTo = null; // 自动清除无效回复ID
    }
    return message_model.Message(
      messages: [message_model.TextModel(text: text)],
      who: who,
      messageId: temp ? -1 : _nextMessageId++,
      timestamp: DateTime.now().millisecondsSinceEpoch.toDouble(),
      replyTo: replyTo,
    );
  }

  void _addMessage(message_model.Message message) {
    messages.add(message);
    notifyListeners();
    scrollToBottom();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
