import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.g.dart';
part 'message_model.freezed.dart';

// 消息类型枚举
enum MessageType {
  text('text'),
  expression('expression');

  final String value;
  const MessageType(this.value);
}

// 文本消息模型
@freezed
abstract class TextModel with _$TextModel {
  const factory TextModel({
    @Default(MessageType.text) MessageType type,
    required String text,
  }) = _TextModel;

  factory TextModel.fromJson(Map<String, dynamic> json) =>
      _$TextModelFromJson(json);
}

// 表情消息模型
@freezed
abstract class ExpressionModel with _$ExpressionModel {
  const factory ExpressionModel({
    @Default(MessageType.expression) MessageType type,
    required int expressionId,
    required String text,
  }) = _ExpressionModel;

  factory ExpressionModel.fromJson(Map<String, dynamic> json) =>
      _$ExpressionModelFromJson(json);
}

// 抽象消息基类
@freezed
abstract class Message with _$Message {
  const factory Message({
    required List<dynamic> messages, // 使用联合类型
    int? replyTo,
    double? timestamp,
    required String who,
    int? messageId,
    @Default({}) Map<String, dynamic> extensions,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

extension MessageExtensions on Message {
  Message? getRepliedMessage(List<Message> allMessages) {
    return replyTo != null
        ? allMessages.firstWhere(
          (m) => m.messageId == replyTo,
          orElse:
              () => Message(
                messages: [TextModel(text: '已删除的消息')],
                who: 'user',
                messageId: -1,
              ),
        )
        : null;
  }

  String getPlainText() {
    return messages
        .map((message) {
          if (message is TextModel) {
            return message.text;
          } else if (message is ExpressionModel) {
            return message.text; // 这里可以根据需要返回表情的文本描述
          }
          return message['text'];
        })
        .join('\n');
  }

  String? getReplyText(List<Message> allMessages) {
    final replied = getRepliedMessage(allMessages);
    if (replied == null) return null;

    final text = replied.getPlainText();
    return text.isEmpty
        ? '[空消息]'
        : (text.length > 30 ? '${text.substring(0, 30)}...' : text);
  }
}
