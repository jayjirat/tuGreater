import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/community_provider.dart';

class CommunityViewpost extends ConsumerStatefulWidget {
  final String id;
  const CommunityViewpost({super.key, required this.id});

  @override
  CommunityViewpostState createState() => CommunityViewpostState();
}

class CommunityViewpostState extends ConsumerState<CommunityViewpost> {
  @override
  void initState() {
    super.initState();
    ref.read(communityProvider.notifier).fetchPost(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(communityProvider);
    final post = ref.read(communityProvider.notifier).post;
    final isLoading = ref.watch(communityProvider.notifier).isLoading;

    final commentCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF914D),
        elevation: 2,
        title: Text(
          isLoading ? "Loading..." : post!.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Color(0xFFFF914D),
                        child: Icon(
                          Icons.account_circle,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        post!.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        post.createdAt.toString(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    post.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      showReportPopup(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFFE63946),
                                        foregroundColor: Colors.white,
                                        elevation: 2),
                                    child: Text("Report post"))
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              post.description,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                "https://fastly.picsum.photos/id/67/200/200.jpg?hmac=sN5XCCMqqmBvgDbYmAowWy2VToCkSYP5igDL_iRxK3M",
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.thumb_up_alt_outlined,
                          label: "${post.likeCount}",
                        ),
                        _buildActionButton(
                          icon: Icons.comment_outlined,
                          label: "${post.comments.length}",
                        ),
                        _buildActionButton(
                          icon: Icons.share_outlined,
                          label: "Share",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    post.comments.isEmpty
                        ? Center(child: Text("No comments"))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: post.comments.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(12),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Color(0xFFFF914D),
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(post.comments[index].username),
                                      Text(
                                        post.comments[index].createdAt
                                            .toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(post.comments[index].text),
                                ),
                              );
                            },
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
        ),
      ),
      bottomSheet: isLoading
          ? null
          : Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentCtrl,
                      decoration: InputDecoration(
                        hintText: "Write a public comment...",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.near_me,
                        color: Color(0xFFFF914D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label}) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFFFF914D)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Color(0xFFFF914D))),
      ],
    );
  }

  void showReportPopup(BuildContext ctx) {
    bool isChecked1 = false;
    bool isChecked2 = false;
    bool isChecked3 = false;
    bool isChecked4 = false;
    final descriptionController = TextEditingController();

    final post = ref.read(communityProvider.notifier).post;

    showDialog(
      context: ctx,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                "Report post: ${post!.title}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title: Text("Uses harsh or offensive language"),
                      value: isChecked1,
                      onChanged: (bool? value) {
                        setState(() => isChecked1 = value!);
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Causes misunderstandings or confusion"),
                      value: isChecked2,
                      onChanged: (bool? value) {
                        setState(() => isChecked2 = value!);
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Contains inappropriate images"),
                      value: isChecked3,
                      onChanged: (bool? value) {
                        setState(() => isChecked3 = value!);
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Others"),
                      value: isChecked4,
                      onChanged: (bool? value) {
                        setState(() => isChecked4 = value!);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: descriptionController,
                        maxLength: 200,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Description",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE63946),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Report"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
