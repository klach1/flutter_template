import '../../../data/model/events/event_note_api_model.dart';

class EventNote {
  final String id;
  final String eventId;
  final String userId;
  final String title;
  final String content;
  final DateTime timestamp;

  const EventNote({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  // Factory constructor to create from API model
  factory EventNote.fromApiModel(EventNoteApiModel apiModel) {
    return EventNote(
      id: apiModel.id,
      eventId: apiModel.eventId,
      userId: apiModel.userId,
      title: apiModel.title,
      content: apiModel.content,
      timestamp: apiModel.timestamp,
    );
  }

  EventNote copyWith({
    String? id,
    String? eventId,
    String? userId,
    String? title,
    String? content,
    DateTime? timestamp,
  }) {
    return EventNote(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventNote && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'EventNote(id: $id, title: $title, userId: $userId)';
}
