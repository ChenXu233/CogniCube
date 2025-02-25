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
}