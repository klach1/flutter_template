import 'location_api_model.dart';
import 'event_task_api_model.dart';

class EventApiModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final LocationApiModel location;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String category;
  final int maxParticipants;
  final int currentParticipants;
  final int maxPilots;
  final int currentPilots;
  final String organizerId;
  final bool isUserRegistered;
  final List<EventTaskApiModel> tasks;
  final List<String> participants;
  final List<String> pilots;

  EventApiModel({
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
    required this.participants,
    required this.pilots,
  });

  factory EventApiModel.fromJson(Map<String, dynamic> json) {
    return EventApiModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      location: LocationApiModel.fromJson(json['location'] as Map<String, dynamic>),
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      category: json['category'] as String,
      maxParticipants: json['maxParticipants'] as int,
      currentParticipants: json['currentParticipants'] as int,
      maxPilots: json['maxPilots'] as int,
      currentPilots: json['currentPilots'] as int,
      organizerId: json['organizerId'] as String,
      isUserRegistered: json['isUserRegistered'] as bool,
      tasks: (json['tasks'] as List<dynamic>)
          .map((taskJson) => EventTaskApiModel.fromJson(taskJson as Map<String, dynamic>))
          .toList(),
      participants: (json['participants'] as List<dynamic>)
          .map((participantId) => participantId as String)
          .toList(),
      pilots: (json['pilots'] as List<dynamic>)
          .map((pilotId) => pilotId as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'location': location.toJson(),
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'category': category,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'maxPilots': maxPilots,
      'currentPilots': currentPilots,
      'organizerId': organizerId,
      'isUserRegistered': isUserRegistered,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'participants': participants,
      'pilots': pilots,
    };
  }
}
