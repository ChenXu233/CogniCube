import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/chat_view_model.dart';
import '../../models/message_model.dart' as message_model;

class MessageBubble extends StatelessWidget {
  final message_model.Message message;

  const MessageBubble({super.key, required this.message});
  void _showContextMenu(BuildContext context) async {
    final renderBox = context.findRenderObject() as RenderBox;
    // 获取消息气泡在屏幕中的位置
    final bubblePosition = renderBox.localToGlobal(Offset.zero);
    final bubbleHeight = renderBox.size.height;
    final menuLeft = bubblePosition.dx;
    final menuTop = bubblePosition.dy + bubbleHeight + 8;
    final menuRight = bubblePosition.dx + renderBox.size.width;
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        menuLeft,
        menuTop,
        menuRight,
        menuTop + 1, // 高度由菜单内容决定
      ),
      items: [
        const PopupMenuItem(
          value: 'reply',
          child: ListTile(
            leading: Icon(Icons.reply, size: 20),
            title: Text('回复'),
            dense: true,
          ),
        ),
      ],
    );

    if (result == 'reply') {
      // 触发回复状态
      context.read<ChatViewModel>().setReplyingTo(message.messageId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.who == 'user';
    final isLoading = message.who == 'loading';

    return GestureDetector(
      onSecondaryTapDown: (details) => _showContextMenu(context),
      onLongPress: () => _showContextMenu(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: Row(
                mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isUser && !isLoading)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.smart_toy, size: 18),
                      ),
                    ),
                  Flexible(
                    child: Container(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getBubbleColor(context, isUser, isLoading),
                          borderRadius: _getBorderRadius(isUser),
                          boxShadow:
                              isLoading
                                  ? null
                                  : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 2,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                        ),
                        child: _buildContent(context, isLoading),
                      ), //
                    ),
                  ),
                  if (isUser && !isLoading)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: CircleAvatar(
                        radius: 16,
                        child: Icon(Icons.person, size: 18),
                      ),
                    ),
                ],
              ),
            ),
            _buildTimestamp(context),
          ],
        ),
      ),
    );
  }

  Color _getBubbleColor(BuildContext context, bool isUser, bool isLoading) {
    if (isLoading) return Colors.grey.shade200;
    return isUser
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface;
  }

  BorderRadius _getBorderRadius(bool isUser) {
    return BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
      bottomRight:
          isUser ? const Radius.circular(4) : const Radius.circular(16),
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    if (isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Text('处理中...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
    }

    return Text(
      message.getPlainText(),
      style: TextStyle(
        color:
            message.who == 'user'
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    final timestamp =
        message.timestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(message.timestamp!.toInt())
            : null;

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        timestamp?.toString().substring(11, 16) ?? '',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
      ),
    );
  }
}
