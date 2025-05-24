import '../../../data/model/events/user_api_model.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String avatarUrl;
  final bool isPilot;
  final bool isOrganizer;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    required this.isPilot,
    required this.isOrganizer,
  });

  // Factory constructor to create from API model
  factory User.fromApiModel(UserApiModel apiModel) {
    return User(
      id: apiModel.id,
      username: apiModel.username,
      email: apiModel.email,
      fullName: apiModel.fullName,
      avatarUrl: apiModel.avatarUrl,
      isPilot: apiModel.isPilot,
      isOrganizer: apiModel.isOrganizer,
    );
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? fullName,
    String? avatarUrl,
    bool? isPilot,
    bool? isOrganizer,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPilot: isPilot ?? this.isPilot,
      isOrganizer: isOrganizer ?? this.isOrganizer,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, username: $username, fullName: $fullName)';
}
