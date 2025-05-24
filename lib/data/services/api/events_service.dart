import 'dart:convert';
import 'package:flutter/services.dart';
import '../api_client.dart';
import '../../model/events/event_api_model.dart';
import '../../model/events/user_api_model.dart';
import '../../model/events/chat_message_api_model.dart';
import '../../model/events/event_note_api_model.dart';

class EventsService {
  // Pro demo účely používáme local JSON soubor
  // V produkci by zde byl ApiClient
  EventsService({required ApiClient apiClient});

  Future<List<EventApiModel>> getEvents() async {
    try {
      // Pro demo účely načítáme z local JSON souboru
      // V produkci by to bylo: final response = await _client.get('/events');
      final String jsonString = await rootBundle.loadString('assets/fake_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> eventsJson = jsonData['events'] as List<dynamic>;
      return eventsJson
          .map((eventJson) => EventApiModel.fromJson(eventJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Chyba při načítání událostí: $e');
    }
  }

  Future<EventApiModel> getEventById(String eventId) async {
    try {
      final events = await getEvents();
      return events.firstWhere(
        (event) => event.id == eventId,
        orElse: () => throw Exception('Událost s ID $eventId nebyla nalezena'),
      );
    } catch (e) {
      throw Exception('Chyba při načítání události: $e');
    }
  }

  Future<List<EventApiModel>> getEventsByCategory(String category) async {
    try {
      final events = await getEvents();
      return events.where((event) => event.category == category).toList();
    } catch (e) {
      throw Exception('Chyba při filtrování událostí podle kategorie: $e');
    }
  }

  Future<List<EventApiModel>> getEventsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final events = await getEvents();
      return events.where((event) {
        return event.startDateTime.isAfter(startDate) && 
               event.startDateTime.isBefore(endDate);
      }).toList();
    } catch (e) {
      throw Exception('Chyba při filtrování událostí podle data: $e');
    }
  }

  Future<List<UserApiModel>> getUsers() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/fake_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> usersJson = jsonData['users'] as List<dynamic>;
      return usersJson
          .map((userJson) => UserApiModel.fromJson(userJson as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Chyba při načítání uživatelů: $e');
    }
  }

  Future<UserApiModel> getUserById(String userId) async {
    try {
      final users = await getUsers();
      return users.firstWhere(
        (user) => user.id == userId,
        orElse: () => throw Exception('Uživatel s ID $userId nebyl nalezen'),
      );
    } catch (e) {
      throw Exception('Chyba při načítání uživatele: $e');
    }
  }

  Future<List<ChatMessageApiModel>> getChatMessages(String eventId) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/fake_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> messagesJson = jsonData['chatMessages'] as List<dynamic>;
      return messagesJson
          .map((messageJson) => ChatMessageApiModel.fromJson(messageJson as Map<String, dynamic>))
          .where((message) => message.eventId == eventId)
          .toList();
    } catch (e) {
      throw Exception('Chyba při načítání chat zpráv: $e');
    }
  }

  Future<List<EventNoteApiModel>> getEventNotes(String eventId) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/fake_data.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      final List<dynamic> notesJson = jsonData['eventNotes'] as List<dynamic>;
      return notesJson
          .map((noteJson) => EventNoteApiModel.fromJson(noteJson as Map<String, dynamic>))
          .where((note) => note.eventId == eventId)
          .toList();
    } catch (e) {
      throw Exception('Chyba při načítání poznámek: $e');
    }
  }

  Future<bool> registerForEvent(String eventId, String userId) async {
    try {
      // V produkci by to bylo API volání
      // final response = await _client.post('/events/$eventId/register', data: {'userId': userId});
      // Pro demo vracíme true
      return true;
    } catch (e) {
      throw Exception('Chyba při přihlašování na událost: $e');
    }
  }

  Future<bool> unregisterFromEvent(String eventId, String userId) async {
    try {
      // V produkci by to bylo API volání
      // final response = await _client.delete('/events/$eventId/register/$userId');
      // Pro demo vracíme true
      return true;
    } catch (e) {
      throw Exception('Chyba při odhlašování z události: $e');
    }
  }

  Future<ChatMessageApiModel> sendChatMessage(String eventId, String userId, String message) async {
    try {
      // V produkci by to bylo API volání
      // final response = await _client.post('/events/$eventId/chat', data: {
      //   'userId': userId,
      //   'message': message,
      // });
      
      // Pro demo vytvoříme fake zprávu
      return ChatMessageApiModel(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        eventId: eventId,
        userId: userId,
        message: message,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Chyba při odesílání zprávy: $e');
    }
  }

  Future<EventNoteApiModel> createEventNote(String eventId, String userId, String title, String content) async {
    try {
      // V produkci by to bylo API volání
      // final response = await _client.post('/events/$eventId/notes', data: {
      //   'userId': userId,
      //   'title': title,
      //   'content': content,
      // });
      
      // Pro demo vytvoříme fake poznámku
      return EventNoteApiModel(
        id: 'note_${DateTime.now().millisecondsSinceEpoch}',
        eventId: eventId,
        userId: userId,
        title: title,
        content: content,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Chyba při vytváření poznámky: $e');
    }
  }
}
