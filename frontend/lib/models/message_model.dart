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
  String getPlainText() {
    String text = '';
    for (var message in messages) {
      if (message is TextModel) {
        text += message.text;
      } else if (message is ExpressionModel) {
        text += message.text;
      }
    }
    return text;
  }
}
