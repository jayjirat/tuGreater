import 'package:frontend/models/role.dart';

class User {
  final String id;
  final String studentId;
  final String username;
  final String displayName;
  final String profileImageUrl;
  final Role role;

  User(
      {required this.id,
      required this.studentId,
      required this.username,
      required this.displayName,
      required this.profileImageUrl,
      required this.role});
}
