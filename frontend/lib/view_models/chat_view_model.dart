// chat_view_model.dart
import 'package:flutter/material.dart';
import '../models/message_model.dart' as message_model;
import '../services/chat.dart';
import '../utils/constants.dart';

class ChatViewModel extends ChangeNotifier {
  int? _replyingToMessageId;
  String get replyingPreview => _getReplyingPreview();

  int _nextMessageId = 1001;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool isSendButtonEnabled = false;
  bool isLoadingMore = false;
  List<message_model.Message> messages = [];

  void setReplyingTo(int? messageId) {
    _replyingToMessageId = messageId;
    notifyListeners();
  }

  void clearReply() {
    setReplyingTo(null);
  }

  String _getReplyingPreview() {
    if (_replyingToMessageId == null) return '';
    final message = messages.firstWhere(
      (m) => m.messageId == _replyingToMessageId,
      orElse:
          () => message_model.Message(
            messages: [message_model.TextModel(text: '已删除的消息')],
            who: 'user',
            messageId: -1,
          ),
    );
    return message.getPlainText();
  }

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
        timestamp: DateTime.now().millisecondsSinceEpoch / 1000, // 秒级时间戳
      ),
    ];
  }

  Future<List<message_model.Message>> _fetchApiMessages() async {
    // 获取当前北京时间
    final now = DateTime.now().toUtc().add(const Duration(hours: 8));

    // 计算当天北京时间零点
    final todayStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).toUtc().add(const Duration(hours: 8));

    final int timeEnd;
    if (messages.isEmpty) {
      timeEnd = (now.millisecondsSinceEpoch / 1000).round(); // 当前北京时间秒级
    } else {
      timeEnd = messages.first.timestamp?.round() ?? 0;
    }

    // 计算24小时前的时间戳
    final int timeStart =
        (todayStart.millisecondsSinceEpoch / 1000).round() - 60 * 60 * 24;

    return await ChatApiService.getChatHistory(timeStart, timeEnd);
  }

  void updateSendButtonState(String text) {
    isSendButtonEnabled = text.trim().isNotEmpty;
    notifyListeners();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> sendMessage(String text) async {
    final userMessage = _createMessage(
      text,
      'user',
      replyTo: _replyingToMessageId,
    );
    _addMessage(userMessage);
    clearReply();

    message_model.Message? loadingMessage; // 声明加载消息变量

    try {
      // 创建并添加加载消息
      loadingMessage = _createMessage('正在加载...', 'loading', temp: true);
      _addMessage(loadingMessage);

      final response = await ChatApiService.getAIResponse(text);

      // 移除加载消息
      messages.remove(loadingMessage);
      notifyListeners();

      final aiMessage = _createMessage(
        response,
        'assistant',
        replyTo: userMessage.messageId,
      );
      _addMessage(aiMessage);
    } catch (e) {
      // 确保移除加载消息
      if (loadingMessage != null) {
        messages.remove(loadingMessage);
        notifyListeners();
      }

      // 添加错误消息
      _addMessage(
        _createMessage(
          '发生错误，请稍后再试:$e',
          'assistant',
          replyTo: userMessage.messageId,
        ),
      );
    }
  }

  message_model.Message _createMessage(
    String text,
    String who, {
    int? replyTo,
    bool temp = false,
  }) {
    // 添加回复消息校验
    int? finalReplyTo = replyTo;
    if (who == 'assistant' && replyTo != null) {
      final userMessages = messages.where((m) => m.who == 'user');
      if (userMessages.isNotEmpty) {
        finalReplyTo = userMessages.last.messageId;
      }
    }
    final beijingTime = DateTime.now().toUtc().add(const Duration(hours: 8));
    return message_model.Message(
      messages: [message_model.TextModel(text: text)],
      who: who,
      messageId: temp ? -1 : _nextMessageId++,
      timestamp: beijingTime.millisecondsSinceEpoch / 1000 + 8 * 60 * 60,
      replyTo: finalReplyTo,
    );
  }

  void _addMessage(message_model.Message message) {
    messages.add(message);
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
