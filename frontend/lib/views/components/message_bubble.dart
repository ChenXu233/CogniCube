import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/chat_view_model.dart';
import '../../models/message_model.dart' as message_model;

class MessageBubble extends StatelessWidget {
  final message_model.Message message;
  final _messageTypes = const {'user', 'assistant', 'loading'};

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.who == 'user';
    final isLoading = message.who == 'loading';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (message.replyTo != null) _buildReplyPreview(context),
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser && !isLoading)
                const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.smart_toy, size: 18),
                ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
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
                ),
              ),
            ],
          ),
          _buildTimestamp(context),
        ],
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.reply, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              replyText ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
