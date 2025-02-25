import 'package:flutter/material.dart';
import '../../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final isLoading = message.type == MessageType.loading;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                    color: isLoading 
                        ? Colors.grey[200]
                        : (isUser ? Colors.blue : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      if (!isLoading)
                        const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                    ],
                  ),
                  child: isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 12),
                            Text('Processing...'),
                          ],
                        )
                      : Text(
                          message.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? time) {
    return '${time?.hour.toString().padLeft(2, '0')}:${time?.minute.toString().padLeft(2, '0')}';
  }
}