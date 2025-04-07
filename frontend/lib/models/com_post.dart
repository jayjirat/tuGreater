import 'package:frontend/models/comment.dart';

class CommuPost {
  final String id;
  final String title;
  final String description;
  final String category;
  int likeCount;
  final List<Comment> comments;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String userId;
  final String username;
  final List<String> likedBy;
  final bool isEdited;
  final String? imageUrl;
  final bool isPinned;

  CommuPost({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.likeCount = 0,
    this.comments = const [],
    required this.createdAt,
    this.updatedAt,
    required this.userId,
    required this.username,
    this.likedBy = const [],
    this.isEdited = false,
    this.imageUrl,
    this.isPinned = false,
  });

  // ฟังก์ชันแปลง JSON เป็น CommuPost
  factory CommuPost.fromJson(Map<String, dynamic> json) {
    return CommuPost(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      likeCount: json['likeCount'] as int? ?? 0,
      comments: (json['comments'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      userId: json['userId'] as String,
      username: json['username'] as String,
      likedBy: List<String>.from(json['likedBy'] ?? []),
      isEdited: json['isEdited'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
    );
  }
}
