import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/report_provider.dart';

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
                    trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Delete Report"),
                            content: Text("Are you sure you want to delete this report?"),
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
                            await ref.read(reportProvider.notifier).deleteReport(report.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Report deleted")),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to delete report: $e")),
                            );
                          }
                        }
                      },
                  ),
                );
              },
            ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Color(0xFFFF9000),
      title: Text(
        "Delete Post", 
        style: TextStyle(
          fontWeight: FontWeight.bold),),
      centerTitle: true,
    );
  }
}