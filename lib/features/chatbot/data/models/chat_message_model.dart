enum MessageType { user, ai }

class ChatMessageModel {
  final String id;
  final MessageType type;
  final String content;
  final DateTime timestamp;
  final bool isError;

  ChatMessageModel({
    required this.id,
    required this.type,
    required this.content,
    required this.timestamp,
    this.isError = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isError': isError,
    };
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'],
      type: json['type'] == 'user' ? MessageType.user : MessageType.ai,
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isError: json['isError'] ?? false,
    );
  }
}