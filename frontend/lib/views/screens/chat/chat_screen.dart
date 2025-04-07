// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/chat_view_model.dart';
import '../../../views/components/message_bubble.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel _vm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<ChatViewModel>();
      vm.fetchMoreMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(child: _buildMessageList()),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.push('/home'),
      ),
      title: const Text('Chat'),
    );
  }

  Widget _buildMessageList() {
    return Consumer<ChatViewModel>(
      builder: (context, vm, _) {
        return NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels == 0) {
              vm.fetchMoreMessages();
            }
            return true;
          },
          child: ListView.builder(
            reverse: true,
            controller: vm.scrollController,
            padding: const EdgeInsets.all(8),
            itemCount: vm.messages.length + 1,
            itemBuilder: (context, index) {
              if (index == vm.messages.length) {
                return _buildLoadingIndicator(vm);
              }
              return MessageBubble(message: vm.messages[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(ChatViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child:
            vm.isLoadingMore
                ? const CircularProgressIndicator()
                : const Text('没有更多消息了'),
      ),
    );
  }

  Widget _buildInputArea() {
    return Consumer<ChatViewModel>(
      builder: (context, vm, _) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: vm.messageController,
                  decoration: InputDecoration(
                    hintText: '输入消息...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onChanged: vm.updateSendButtonState,
                  onSubmitted: (text) => _sendMessage(text),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                color: Colors.blue,
                onPressed:
                    vm.isSendButtonEnabled
                        ? () => _sendMessage(vm.messageController.text)
                        : null,
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage(String text) {
    final vm = context.read<ChatViewModel>();
    vm.sendMessage(text);
    vm.messageController.clear();
    vm.updateSendButtonState('');
  }
}
