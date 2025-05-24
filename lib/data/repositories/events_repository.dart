import '../services/api/events_service.dart';
import '../../domain/models/events/event.dart';
import '../../domain/models/events/user.dart';
import '../../domain/models/events/chat_message.dart';
import '../../domain/models/events/event_note.dart';
import '../../domain/models/events/event_category.dart';

class EventsRepository {
  final EventsService _service;

  EventsRepository({required EventsService service}) : _service = service;

  Future<List<Event>> getEvents() async {
    try {
      final apiEvents = await _service.getEvents();
      return apiEvents.map((apiEvent) => Event.fromApiModel(apiEvent)).toList();
    } catch (e) {
      throw Exception('Nepodařilo se načíst události: $e');
    }
  }

  Future<Event> getEventById(String eventId) async {
    try {
      final apiEvent = await _service.getEventById(eventId);
      return Event.fromApiModel(apiEvent);
    } catch (e) {
      throw Exception('Nepodařilo se načíst událost: $e');
    }
  }

  Future<List<Event>> getEventsByCategory(EventCategory category) async {
    try {
      final apiEvents = await _service.getEventsByCategory(category.value);
      return apiEvents.map((apiEvent) => Event.fromApiModel(apiEvent)).toList();
    } catch (e) {
      throw Exception('Nepodařilo se filtrovat události podle kategorie: $e');
    }
  }

  Future<List<Event>> getEventsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final apiEvents = await _service.getEventsByDateRange(startDate, endDate);
      return apiEvents.map((apiEvent) => Event.fromApiModel(apiEvent)).toList();
    } catch (e) {
      throw Exception('Nepodařilo se filtrovat události podle data: $e');
    }
  }

  Future<List<User>> getUsers() async {
    try {
      final apiUsers = await _service.getUsers();
      return apiUsers.map((apiUser) => User.fromApiModel(apiUser)).toList();
    } catch (e) {
      throw Exception('Nepodařilo se načíst uživatele: $e');
    }
  }

  Future<User> getUserById(String userId) async {
    try {
      final apiUser = await _service.getUserById(userId);
      return User.fromApiModel(apiUser);
    } catch (e) {
      throw Exception('Nepodařilo se načíst uživatele: $e');
    }
  }

  Future<List<User>> getEventParticipants(String eventId) async {
    try {
      final event = await getEventById(eventId);
      final allUsers = await getUsers();
      
      return allUsers.where((user) => event.participantIds.contains(user.id)).toList();
    } catch (e) {
      throw Exception('Nepodařilo se načíst účastníky události: $e');
    }
  }

  Future<List<User>> getEventPilots(String eventId) async {
    try {
      final event = await getEventById(eventId);
      final allUsers = await getUsers();
      
      return allUsers.where((user) => event.pilotIds.contains(user.id)).toList();
    } catch (e) {
      throw Exception('Nepodařilo se načíst piloty události: $e');
    }
  }

  Future<List<ChatMessage>> getChatMessages(String eventId) async {
    try {
      final apiMessages = await _service.getChatMessages(eventId);
      return apiMessages.map((apiMessage) => ChatMessage.fromApiModel(apiMessage)).toList();
    } catch (e) {
      throw Exception('Nepodařilo se načíst chat zprávy: $e');
    }
  }

  Future<List<EventNote>> getEventNotes(String eventId) async {
    try {
      final apiNotes = await _service.getEventNotes(eventId);
      return apiNotes.map((apiNote) => EventNote.fromApiModel(apiNote)).toList();
    } catch (e) {
      throw Exception('Nepodařilo se načíst poznámky: $e');
    }
  }

  Future<bool> registerForEvent(String eventId, String userId) async {
    try {
      return await _service.registerForEvent(eventId, userId);
    } catch (e) {
      throw Exception('Nepodařilo se přihlásit na událost: $e');
    }
  }

  Future<bool> unregisterFromEvent(String eventId, String userId) async {
    try {
      return await _service.unregisterFromEvent(eventId, userId);
    } catch (e) {
      throw Exception('Nepodařilo se odhlásit z události: $e');
    }
  }

  Future<ChatMessage> sendChatMessage(String eventId, String userId, String message) async {
    try {
      final apiMessage = await _service.sendChatMessage(eventId, userId, message);
      return ChatMessage.fromApiModel(apiMessage);
    } catch (e) {
      throw Exception('Nepodařilo se odeslat zprávu: $e');
    }
  }

  Future<EventNote> createEventNote(String eventId, String userId, String title, String content) async {
    try {
      final apiNote = await _service.createEventNote(eventId, userId, title, content);
      return EventNote.fromApiModel(apiNote);
    } catch (e) {
      throw Exception('Nepodařilo se vytvořit poznámku: $e');
    }
  }
}
