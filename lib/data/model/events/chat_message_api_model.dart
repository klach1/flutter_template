class ChatMessageApiModel {
  final String id;
  final String eventId;
  final String userId;
  final String message;
  final DateTime timestamp;

  ChatMessageApiModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessageApiModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageApiModel(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
