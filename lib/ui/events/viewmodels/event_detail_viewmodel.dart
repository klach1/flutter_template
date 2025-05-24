import 'package:flutter/material.dart';
import '../../../data/repositories/events_repository.dart';
import '../../../domain/models/events/event.dart';
import '../../../domain/models/events/user.dart';
import '../../../domain/models/events/chat_message.dart';
import '../../../domain/models/events/event_note.dart';

class EventDetailViewModel extends ChangeNotifier {
  final EventsRepository _repository;
  final String eventId;

  // State variables
  bool _isLoading = false;
  String? _error;
  Event? _event;
  List<User> _participants = [];
  List<User> _pilots = [];
  List<ChatMessage> _chatMessages = [];
  List<EventNote> _eventNotes = [];
  bool _isLoadingParticipants = false;
  bool _isLoadingMessages = false;
  bool _isLoadingNotes = false;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  Event? get event => _event;
  List<User> get participants => _participants;
  List<User> get pilots => _pilots;
  List<ChatMessage> get chatMessages => _chatMessages;
  List<EventNote> get eventNotes => _eventNotes;
  bool get isLoadingParticipants => _isLoadingParticipants;
  bool get isLoadingMessages => _isLoadingMessages;
  bool get isLoadingNotes => _isLoadingNotes;

  EventDetailViewModel({
    required EventsRepository repository,
    required this.eventId,
  }) : _repository = repository;

  Future<void> loadEventDetail() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _event = await _repository.getEventById(eventId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadParticipants() async {
    if (_isLoadingParticipants) return;

    _isLoadingParticipants = true;
    notifyListeners();

    try {
      _participants = await _repository.getEventParticipants(eventId);
      _pilots = await _repository.getEventPilots(eventId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingParticipants = false;
      notifyListeners();
    }
  }

  Future<void> loadChatMessages() async {
    if (_isLoadingMessages) return;

    _isLoadingMessages = true;
    notifyListeners();

    try {
      _chatMessages = await _repository.getChatMessages(eventId);
      // Sort messages by timestamp (newest first)
      _chatMessages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMessages = false;
      notifyListeners();
    }
  }

  Future<void> loadEventNotes() async {
    if (_isLoadingNotes) return;

    _isLoadingNotes = true;
    notifyListeners();

    try {
      _eventNotes = await _repository.getEventNotes(eventId);
      // Sort notes by timestamp (newest first)
      _eventNotes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingNotes = false;
      notifyListeners();
    }
  }

  Future<bool> registerForEvent(String userId) async {
    try {
      final success = await _repository.registerForEvent(eventId, userId);
      if (success && _event != null) {
        _event = _event!.copyWith(
          isUserRegistered: true,
          currentParticipants: _event!.currentParticipants + 1,
        );
        notifyListeners();
        // Reload participants to get updated list
        await loadParticipants();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> unregisterFromEvent(String userId) async {
    try {
      final success = await _repository.unregisterFromEvent(eventId, userId);
      if (success && _event != null) {
        _event = _event!.copyWith(
          isUserRegistered: false,
          currentParticipants: _event!.currentParticipants - 1,
        );
        notifyListeners();
        // Reload participants to get updated list
        await loadParticipants();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendChatMessage(String userId, String message) async {
    try {
      final chatMessage = await _repository.sendChatMessage(eventId, userId, message);
      _chatMessages.insert(0, chatMessage); // Add to beginning (newest first)
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createEventNote(String userId, String title, String content) async {
    try {
      final note = await _repository.createEventNote(eventId, userId, title, content);
      _eventNotes.insert(0, note); // Add to beginning (newest first)
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> refreshAll() async {
    await Future.wait([
      loadEventDetail(),
      loadParticipants(),
      loadChatMessages(),
      loadEventNotes(),
    ]);
  }
}
