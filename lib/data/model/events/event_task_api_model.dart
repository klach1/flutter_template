class EventTaskApiModel {
  final String id;
  final String title;
  final bool isCompleted;

  EventTaskApiModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory EventTaskApiModel.fromJson(Map<String, dynamic> json) {
    return EventTaskApiModel(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}
