class CommuPost {
  final String id;
  final String title;
  final String description;
  final String category;
  int likeCount;
  int commentCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final String username;
  final bool isEdited;
  final String? imageUrl;
  String? postedByImageUrl;

  int repostCount;
  final bool isReposted;
  final String? repostedUserId;
  final String? repostedUsername;
  final String? repostedPostId;

  CommuPost(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      this.likeCount = 0,
      this.commentCount = 0,
      this.repostCount = 0,
      required this.createdAt,
      required this.updatedAt,
      required this.userId,
      required this.username,
      this.isEdited = false,
      this.imageUrl,
      this.isReposted = false,
      this.repostedUserId,
      this.repostedPostId,
      this.postedByImageUrl,
      this.repostedUsername});

  // ฟังก์ชันแปลง JSON เป็น CommuPost
  factory CommuPost.fromJson(Map<String, dynamic> json) {
    return CommuPost(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      repostCount: json['repostCount'] as int? ?? 0, // เพิ่ม repostCount
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      userId: json['userId'] as String,
      username: json['username'] as String,
      isEdited: json['isEdited'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      isReposted: json['isReposted'] as bool,
      repostedUserId: json['repostedUserId'] as String?,
      repostedPostId: json['repostedPostId'] as String?,
      postedByImageUrl: json['postedByImageUrl'] as String?,
      repostedUsername: json['repostedUsername'] as String?,
    );
  }
}
