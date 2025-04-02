// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TextModel _$TextModelFromJson(Map<String, dynamic> json) => _TextModel(
  type:
      $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
      MessageType.text,
  text: json['text'] as String,
);

Map<String, dynamic> _$TextModelToJson(_TextModel instance) =>
    <String, dynamic>{
      'type': _$MessageTypeEnumMap[instance.type]!,
      'text': instance.text,
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.expression: 'expression',
};

_ExpressionModel _$ExpressionModelFromJson(Map<String, dynamic> json) =>
    _ExpressionModel(
      type:
          $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.expression,
      expressionId: (json['expressionId'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$ExpressionModelToJson(_ExpressionModel instance) =>
    <String, dynamic>{
      'type': _$MessageTypeEnumMap[instance.type]!,
      'expressionId': instance.expressionId,
      'text': instance.text,
    };

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  messages: json['messages'] as List<dynamic>,
  replyTo: (json['replyTo'] as num?)?.toInt(),
  timestamp: (json['timestamp'] as num?)?.toDouble(),
  who: json['who'] as String,
  messageId: (json['messageId'] as num?)?.toInt(),
  extensions: json['extensions'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'messages': instance.messages,
  'replyTo': instance.replyTo,
  'timestamp': instance.timestamp,
  'who': instance.who,
  'messageId': instance.messageId,
  'extensions': instance.extensions,
};
