import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/chat_view_model.dart';
import '../../models/message_model.dart' as message_model;

class MessageBubble extends StatelessWidget {
  final message_model.Message message;
  // final _messageTypes = const {'user', 'assistant', 'loading'};

  const MessageBubble({super.key, required this.message});
  // 新增方法：显示上下文菜单
  void _showContextMenu(BuildContext context, Offset position) async {
    final renderBox = context.findRenderObject() as RenderBox;
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx + renderBox.size.width,
        position.dy + renderBox.size.height,
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
      onSecondaryTapDown:
          (details) => _showContextMenu(context, details.globalPosition),
      onLongPress:
          () => _showContextMenu(context, context.size!.center(Offset.zero)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (message.who == 'assistant') _buildReplyPreview(context),
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

  Widget _buildReplyPreview(BuildContext context) {
    final chatVM = Provider.of<ChatViewModel>(context, listen: false);
    final replyText = message.getReplyText(chatVM.messages);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      constraints: const BoxConstraints(maxWidth: 300), // 限制最大宽度
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 4,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.reply,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  replyText == null ? '最新消息' : '回复',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              replyText ?? _getDefaultReplyText(chatVM.messages),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getDefaultReplyText(List<message_model.Message> messages) {
    final lastUserMessage = messages.lastWhere(
      (m) => m.who == 'user',
      orElse:
          () => message_model.Message(
            messages: [message_model.TextModel(text: '未知消息')],
            who: 'user',
            messageId: -1,
          ),
    );
    final text = lastUserMessage.getPlainText();
    return text.length > 30 ? '${text.substring(0, 30)}...' : text;
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
