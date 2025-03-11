import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/chat_view_model.dart';
import '../../models/message_model.dart' as message_model;

class MessageBubble extends StatelessWidget {
  final message_model.Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.who == "user";
    final isLoading = message.who == "loading";

    return Listener(
      onPointerDown: (event) {
        if (event.buttons == 2) {
          // 修改此处
          _showContextMenu(context, globalPosition: event.position);
        }
      },
      child: GestureDetector(
        onLongPressStart: (details) {
          _showContextMenu(context, globalPosition: details.globalPosition);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
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
                        color:
                            isLoading
                                ? Colors.grey[200]
                                : (isUser ? Colors.blue : Colors.white),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          if (!isLoading)
                            const BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                        ],
                      ),
                      child:
                          isLoading
                              ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Processing...'),
                                ],
                              )
                              : Text(
                                message.plainText,
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
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(
    BuildContext context, {
    required Offset? globalPosition,
  }) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final position =
        globalPosition != null
            ? RelativeRect.fromLTRB(
              globalPosition.dx,
              globalPosition.dy,
              overlay.size.width - globalPosition.dx,
              overlay.size.height - globalPosition.dy,
            )
            : RelativeRect.fromLTRB(
              0,
              0,
              overlay.size.width,
              overlay.size.height,
            );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem<String>(
          value: 'reply',
          child: Row(
            children: const [
              Icon(Icons.reply),
              SizedBox(width: 8),
              Text('Reply'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'reply') {
        _replyToMessage(context, message.plainText);
      }
    });
  }

  void _replyToMessage(BuildContext context, String text) {
    final chatVM = context.read<ChatViewModel>();
    chatVM.messageController.text = '$text ';
    chatVM.messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: chatVM.messageController.text.length),
    );
    chatVM.updateSendButtonState(true);
    FocusScope.of(context).requestFocus(chatVM.messageFocusNode);
  }

  String _formatTime(DateTime? time) {
    return '${time?.hour.toString().padLeft(2, '0')}:${time?.minute.toString().padLeft(2, '0')}';
  }
}
