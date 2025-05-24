class UserApiModel {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final String avatarUrl;
  final bool isPilot;
  final bool isOrganizer;

  UserApiModel({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.avatarUrl,
    required this.isPilot,
    required this.isOrganizer,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) {
    return UserApiModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String,
      isPilot: json['isPilot'] as bool,
      isOrganizer: json['isOrganizer'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'isPilot': isPilot,
      'isOrganizer': isOrganizer,
    };
  }
}
