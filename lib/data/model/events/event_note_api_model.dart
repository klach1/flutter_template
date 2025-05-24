class EventNoteApiModel {
  final String id;
  final String eventId;
  final String userId;
  final String title;
  final String content;
  final DateTime timestamp;

  EventNoteApiModel({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  factory EventNoteApiModel.fromJson(Map<String, dynamic> json) {
    return EventNoteApiModel(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'title': title,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
