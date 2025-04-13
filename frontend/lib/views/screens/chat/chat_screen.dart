// chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/chat_view_model.dart';
import '../../../views/components/message_bubble.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui'; // 导入ImageFilter

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel vm;

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
      body: Stack(
        children: [
          // 主内容区域（消息列表 + 输入框）
          Positioned.fill(
            child: Column(
              children: [
                Expanded(child: _buildMessageList()),
                _buildInputArea(),
              ],
            ),
          ),

          // 模糊透明导航栏
          _buildBlurAppBar(context),
        ],
      ),
    );
  }

  Widget _buildBlurAppBar(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // 模糊参数
          child: Container(
            padding: EdgeInsets.only(top: statusBarHeight),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5), // 半透明白色
              border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.push('/home'),
              ),
              title: const Text(
                'Chat',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return Consumer<ChatViewModel>(
      builder: (context, vm, _) {
        return NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            if (notification.metrics.extentBefore == 0) {
              vm.fetchMoreMessages();
            }
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8), // 移除顶部padding
            child: ListView.builder(
              reverse: true,
              controller: vm.scrollController,
              padding: const EdgeInsets.fromLTRB(
                8,
                kToolbarHeight + 40,
                8,
                8,
              ), // 调整顶部留白
              itemCount: vm.messages.length + 1,
              itemBuilder: (context, index) {
                if (index == vm.messages.length) {
                  return _buildLoadingIndicator(vm);
                }
                final message = vm.messages[vm.messages.length - index - 1];
                return MessageBubble(message: message);
              },
            ),
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

  Widget _buildReplyPreview(BuildContext context, ChatViewModel vm) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Icon(Icons.reply, color: Colors.blue.shade800, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              vm.replyingPreview,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.blue.shade800),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 20, color: Colors.blue.shade800),
            onPressed: vm.clearReply,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Consumer<ChatViewModel>(
      builder: (context, vm, _) {
        return Column(
          children: [
            if (vm.replyingPreview.isNotEmpty)
              _buildReplyPreview(context, vm), // 新增回复预览
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: vm.messageController,
                      decoration: InputDecoration(
                        hintText: '输入消息...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                      ),
                      onChanged: vm.updateSendButtonState,
                      onSubmitted: (text) => _sendMessage(text),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor:
                        vm.isSendButtonEnabled
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey,
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed:
                          vm.isSendButtonEnabled
                              ? () => _sendMessage(vm.messageController.text)
                              : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
