class Report {
  final String id;
  final List<String> reportReasons;
  final String additionalInfo;
  final ReportStatus status;
  final String reportedBy;
  final String postId;
  final PostCategory postCategory;
  final DateTime createdAt;
  final DateTime updatedAt;

  Report(
      {required this.id,
      required this.reportReasons,
      required this.additionalInfo,
      required this.status,
      required this.reportedBy,
      required this.postId,
      required this.postCategory,
      required this.createdAt,
      required this.updatedAt});

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      reportReasons: List<String>.from(json['reportReasons']),
      additionalInfo: json['additionalInfo'],
      status: ReportStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReportStatus.underReview,
      ),
      reportedBy: json['reportedBy'],
      postId: json['postId'],
      postCategory: PostCategory.values.firstWhere(
        (e) => e.name == json['postCategory'],
        orElse: () => PostCategory.community,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

enum ReportStatus { underReview, resolved, rejected }

enum PostCategory { community, shop }
