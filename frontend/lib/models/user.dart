import 'package:frontend/models/role.dart';

class User {
  final String id;
  final String studentId;
  final String username;
  final String displayName;
  String profileImageUrl;
  final Role role;

  User(
      {required this.id,
      required this.studentId,
      required this.username,
      required this.displayName,
      required this.profileImageUrl,
      required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      studentId: json['studentId'],
      username: json['username'],
      displayName: json['displayName'],
      profileImageUrl: json['profileImageUrl'],
      role: json['role'],
    );
  }
}
