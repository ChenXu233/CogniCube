// enum MessageType { user, ai, loading }

class Message {
  final String text;
  final DateTime timestamp;
  final String type;
  final int? id;
  final int? reply_to;

  Message({
    required this.text,
    required this.type,
    this.id,
    this.reply_to,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      type: json['who'],
      id: json['message_id'],
      timestamp: DateTime.fromMillisecondsSinceEpoch((json['timestamp']*1000).toInt()),
      reply_to: json['reply_to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'id': id,      
    };
  }
}