enum MessageType { user, ai, loading }

class Message {
  final String text;
  final DateTime timestamp;
  final MessageType type;
  final String? id;

  Message({
    required this.text,
    required this.type,
    this.id,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  static Message fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      type: json['who'],
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type.name,
      'id': id,      
    };
  }
}