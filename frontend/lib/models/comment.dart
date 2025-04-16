class Comment {
  final String id;
  final String content;
  final String username; // mock data
  final DateTime createdAt;
  final String userId;
  final String postId;

  String? commentedByImageUrl;

  Comment(
      {required this.id,
      required this.content,
      required this.createdAt,
      required this.postId,
      required this.username,
      required this.userId,
      this.commentedByImageUrl});

  // fromJson function
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'] as String,
        content: json['content'] as String,
        username: json['username'] as String,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : DateTime.now(),
        userId: json['userId'] as String,
        postId: json['postId'] as String,
        commentedByImageUrl: json['commentedByImageUrl'] as String?);
  }
}
