import 'location.dart';
import 'event_task.dart';
import 'event_category.dart';
import '../../../data/model/events/event_api_model.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final Location location;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final EventCategory category;
  final int maxParticipants;
  final int currentParticipants;
  final int maxPilots;
  final int currentPilots;
  final String organizerId;
  final bool isUserRegistered;
  final List<EventTask> tasks;
  final List<String> participantIds;
  final List<String> pilotIds;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.startDateTime,
    required this.endDateTime,
    required this.category,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.maxPilots,
    required this.currentPilots,
    required this.organizerId,
    required this.isUserRegistered,
    required this.tasks,
    required this.participantIds,
    required this.pilotIds,
  });

  // Computed properties
  String get participantsText => '$currentParticipants/$maxParticipants';
  String get pilotsText => '$currentPilots/$maxPilots';
  bool get isFull => currentParticipants >= maxParticipants;
  bool get hasAvailableSlots => currentParticipants < maxParticipants;
  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;
  String get tasksProgress => '$completedTasksCount/${tasks.length} splněno';
  
  // TODO: This should check against current user ID from auth service
  // For now, using a placeholder user ID - in real app this would come from auth service
  bool get isUserOrganizer => organizerId == 'user-001'; // Placeholder - implement with actual user logic

  // Factory constructor to create from API model
  factory Event.fromApiModel(EventApiModel apiModel) {
    return Event(
      id: apiModel.id,
      title: apiModel.title,
      description: apiModel.description,
      imageUrl: apiModel.imageUrl,
      location: Location(
        address: apiModel.location.address,
        latitude: apiModel.location.latitude,
        longitude: apiModel.location.longitude,
      ),
      startDateTime: apiModel.startDateTime,
      endDateTime: apiModel.endDateTime,
      category: EventCategory.fromString(apiModel.category),
      maxParticipants: apiModel.maxParticipants,
      currentParticipants: apiModel.currentParticipants,
      maxPilots: apiModel.maxPilots,
      currentPilots: apiModel.currentPilots,
      organizerId: apiModel.organizerId,
      isUserRegistered: apiModel.isUserRegistered,
      tasks: apiModel.tasks
          .map((taskApi) => EventTask(
                id: taskApi.id,
                title: taskApi.title,
                isCompleted: taskApi.isCompleted,
              ))
          .toList(),
      participantIds: apiModel.participants,
      pilotIds: apiModel.pilots,
    );
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    Location? location,
    DateTime? startDateTime,
    DateTime? endDateTime,
    EventCategory? category,
    int? maxParticipants,
    int? currentParticipants,
    int? maxPilots,
    int? currentPilots,
    String? organizerId,
    bool? isUserRegistered,
    List<EventTask>? tasks,
    List<String>? participantIds,
    List<String>? pilotIds,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      category: category ?? this.category,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      currentParticipants: currentParticipants ?? this.currentParticipants,
      maxPilots: maxPilots ?? this.maxPilots,
      currentPilots: currentPilots ?? this.currentPilots,
      organizerId: organizerId ?? this.organizerId,
      isUserRegistered: isUserRegistered ?? this.isUserRegistered,
      tasks: tasks ?? this.tasks,
      participantIds: participantIds ?? this.participantIds,
      pilotIds: pilotIds ?? this.pilotIds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Event(id: $id, title: $title, category: ${category.displayName})';
}
