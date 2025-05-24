class EventTask {
  final String id;
  final String title;
  final bool isCompleted;

  const EventTask({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  EventTask copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return EventTask(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTask &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ isCompleted.hashCode;

  @override
  String toString() => 'EventTask(id: $id, title: $title, completed: $isCompleted)';
}
