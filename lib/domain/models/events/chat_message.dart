import '../../../data/model/events/chat_message_api_model.dart';

class ChatMessage {
  final String id;
  final String eventId;
  final String userId;
  final String message;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.message,
    required this.timestamp,
  });

  // Factory constructor to create from API model
  factory ChatMessage.fromApiModel(ChatMessageApiModel apiModel) {
    return ChatMessage(
      id: apiModel.id,
      eventId: apiModel.eventId,
      userId: apiModel.userId,
      message: apiModel.message,
      timestamp: apiModel.timestamp,
    );
  }

  ChatMessage copyWith({
    String? id,
    String? eventId,
    String? userId,
    String? message,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ChatMessage(id: $id, userId: $userId, message: $message)';
}
