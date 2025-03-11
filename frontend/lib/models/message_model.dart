class Text {
  final String text;
  final String type;

  Text({required this.text, String? type}) : type = type ?? 'text';

  factory Text.fromJson(Map<String, dynamic> json) {
    return Text(text: json['content'], type: json['type'] ?? 'text');
  }

  Map<String, dynamic> toJson() {
    return {'content': text, 'type': type};
  }
}

class Expression {
  final String expressionId;
  final String content;
  final String detail;
  final String type;

  Expression({
    required this.expressionId,
    required this.detail,
    String? content,
    String? type,
  }) : type = type ?? 'expression',
       content = content ?? '';

  factory Expression.fromJson(Map<String, dynamic> json) {
    return Expression(
      expressionId: json['content'],
      detail: '',
      type: json['type'] ?? 'expression',
    );
  }

  Map<String, dynamic> toJson() {
    return {'content': expressionId, 'type': type};
  }
}

class Message {
  final List<dynamic> messages;
  final DateTime timestamp;
  final String who;
  final int? messageId;
  final int? replyTo;
  String plainText;
  late Map<String, dynamic> extension;

  Message({
    required this.messages,
    required this.who,
    this.messageId,
    this.replyTo,
    DateTime? timestamp,
    Map<String, dynamic>? extensions,
    required extension,
  }) : timestamp = timestamp ?? DateTime.now(),
       plainText = messages
           .map<String>((m) => m.toJson()['content'])
           .join(' '), // 假设 messages 中的元素都有 toString 方法
       extension = extensions ?? {};

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messages:
          json['messages'].map<dynamic>((m) {
            switch (m['type']) {
              case 'text':
                return Text.fromJson(m);
              case 'expression':
                return Expression.fromJson(m);
              default:
                throw Exception('Unsupported message type');
            }
          }).toList(),
      who: json['who'],
      messageId: json['message_id'],
      timestamp:
          json['timestamp'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                (json['timestamp'] * 1000).toInt(),
              )
              : null,
      replyTo: json['reply_to'],
      extension: json['extensions'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((m) => m.toJson()).toList(),
      'message_id': messageId,
      'timestamp': timestamp.millisecondsSinceEpoch ~/ 1000, // 转换为秒
      'who': who,
      'reply_to': replyTo,
      'plain_text': plainText,
      'extensions': extension,
    };
  }
}

// 假设 Text 和 Expression 类已经定
