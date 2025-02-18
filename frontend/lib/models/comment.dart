class Comment {
  final String id;
  final String text;
  final String username; // mock data
  final DateTime? createdAt;
  final String userId;
  final String? parentCommentId; // reply comment
  final int likeCount;
  final int replyCount;
  final List<String> likedBy;
  final bool isEdited;

  Comment({
    required this.id,
    required this.text,
    required this.username,
    required this.createdAt,
    required this.userId,
    this.parentCommentId,
    this.likeCount = 0,
    this.replyCount = 0,
    this.likedBy = const [],
    this.isEdited = false,
  });

  // fromJson function
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      text: json['text'] as String,
      username: json['username'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      userId: json['userId'] as String,
      parentCommentId: json['parentCommentId'] as String?,
      likeCount: json['likeCount'] as int? ?? 0,
      replyCount: json['replyCount'] as int? ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      isEdited: json['isEdited'] as bool? ?? false,
    );
  }
}
