import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/chat_view_model.dart';
import '../../../view_models/auth_view_model.dart'; // 新增
import '../../../views/components/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatScreen> {
  late ChatViewModel chatVM;
  @override
  void initState() {
    super.initState();
    chatVM = context.read<ChatViewModel>();
    try{
       chatVM.fetchMoreMessages();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatVM = context.watch<ChatViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat'),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                if (scrollNotification.metrics.pixels == 0) {
                  chatVM.fetchMoreMessages();
                }
                return true;
              },
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(top: 16),
                controller: chatVM.scrollController,
                itemCount: chatVM.messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == chatVM.messages.length) {
                    return _buildLoadMoreHint(chatVM);
                  }
                  final message = chatVM.messages.reversed.toList()[index];
                  return MessageBubble(message: message);
                },
              ),
            ),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    Provider.of<AuthViewModel>(context, listen: false).logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _buildLoadMoreHint(ChatViewModel viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          viewModel.isLoadingMore ? 'Loading more messages...' : 'No more messages',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final viewModel = context.read<ChatViewModel>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    // 当输入框聚焦时，滚动到最新消息
                    viewModel.scrollToBottom();
                  }
                },
                child: TextField(
                  controller: viewModel.messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onChanged: (text) {
                    viewModel.updateSendButtonState(text.trim().isNotEmpty);
                  },
                  onSubmitted: (text) {
                    _sendMessage(context, text);
                  },
                  autofocus: true, // 自动聚焦
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded),
              color: Colors.blue,
              onPressed: viewModel.isSendButtonEnabled
                  ? () => _sendMessage(context, viewModel.messageController.text)
                  : null, // 禁用发送按钮
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context, String text) {
    if (text.trim().isEmpty) return;
    context.read<ChatViewModel>().sendMessage(text);
    FocusScope.of(context).unfocus();
  }
}