import 'package:flutter/material.dart';
import '../../../data/repositories/events_repository.dart';
import '../../../domain/models/events/event.dart';
import '../../../domain/models/events/event_category.dart';

class EventsViewModel extends ChangeNotifier {
  final EventsRepository _repository;

  // State variables
  bool _isLoading = false;
  String? _error;
  List<Event> _events = [];
  List<Event> _filteredEvents = [];
  EventCategory? _selectedCategory;
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Event> get events => _filteredEvents;
  List<Event> get allEvents => _events;
  EventCategory? get selectedCategory => _selectedCategory;
  DateTime? get filterStartDate => _filterStartDate;
  DateTime? get filterEndDate => _filterEndDate;
  
  bool get hasActiveFilters => 
      _selectedCategory != null || _filterStartDate != null || _filterEndDate != null;

  EventsViewModel({required EventsRepository repository}) : _repository = repository;

  Future<void> loadEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _repository.getEvents();
      _applyFilters();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshEvents() async {
    await loadEvents();
  }

  void filterByCategory(EventCategory? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void filterByDateRange(DateTime? startDate, DateTime? endDate) {
    _filterStartDate = startDate;
    _filterEndDate = endDate;
    _applyFilters();
    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = null;
    _filterStartDate = null;
    _filterEndDate = null;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredEvents = _events.where((event) {
      // Filter by category
      if (_selectedCategory != null && event.category != _selectedCategory) {
        return false;
      }

      // Filter by date range
      if (_filterStartDate != null && event.startDateTime.isBefore(_filterStartDate!)) {
        return false;
      }

      if (_filterEndDate != null && event.startDateTime.isAfter(_filterEndDate!)) {
        return false;
      }

      return true;
    }).toList();

    // Sort events by start date
    _filteredEvents.sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  }

  Future<bool> registerForEvent(String eventId, String userId) async {
    try {
      final success = await _repository.registerForEvent(eventId, userId);
      if (success) {
        // Update local event state
        final eventIndex = _events.indexWhere((event) => event.id == eventId);
        if (eventIndex != -1) {
          _events[eventIndex] = _events[eventIndex].copyWith(
            isUserRegistered: true,
            currentParticipants: _events[eventIndex].currentParticipants + 1,
          );
          _applyFilters();
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> unregisterFromEvent(String eventId, String userId) async {
    try {
      final success = await _repository.unregisterFromEvent(eventId, userId);
      if (success) {
        // Update local event state
        final eventIndex = _events.indexWhere((event) => event.id == eventId);
        if (eventIndex != -1) {
          _events[eventIndex] = _events[eventIndex].copyWith(
            isUserRegistered: false,
            currentParticipants: _events[eventIndex].currentParticipants - 1,
          );
          _applyFilters();
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Event? getEventById(String eventId) {
    try {
      return _events.firstWhere((event) => event.id == eventId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
