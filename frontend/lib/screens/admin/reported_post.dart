import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/report_provider.dart';
import 'package:frontend/models/report.dart';
import 'package:frontend/screens/community/community_view_post.dart';
import 'package:frontend/screens/shop/item_detail.dart';

class ReportedPost extends ConsumerStatefulWidget {
  const ReportedPost({super.key});

  @override
  ReportState createState() => ReportState();
}

class ReportState extends ConsumerState<ReportedPost> {

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    await ref.read(reportProvider.notifier).fetchReports();
  }

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(reportProvider);

    return Scaffold(
      appBar: appBar(),
      body: reports.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ListTile(
                    title: Text("Post ID: ${report.postId}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Reasons: ${report.reportReasons.join(', ')}"),
                        Text("Status: ${report.status.name}"),
                        Text("Category: ${report.postCategory.name}"),
                        Text("Reported By: ${report.reportedBy}"),
                      ],
                    ),
                    trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Delete Post"),
                          content: Text("Are you sure you want to delete this post?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      );

                  if (confirm == true) {
                    try {
                      if (report.postCategory == PostCategory.community) {
                        await ref.read(reportProvider.notifier).deleteCommunityPost(report.postId);
                      } else if(report.postCategory == PostCategory.shop) {
                        await ref.read(reportProvider.notifier).deleteProductPost(report.postId);
                      }
                      await ref.read(reportProvider.notifier).deleteReport(report.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("post deleted")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to delete report: $e")),
                      );
                    }
                  }
                },
              ),
              onTap: () {
                if (report.postCategory == PostCategory.community) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommunityViewpost(id: report.postId)),
                  );
                } else if(report.postCategory == PostCategory.shop) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemDetail(productId: report.postId,)),
                  );
                }
              }
            )
          );
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(
        "Delete Post", 
        style: TextStyle(
          fontWeight: FontWeight.bold,
          ),),
      centerTitle: true,
    );
  }
}