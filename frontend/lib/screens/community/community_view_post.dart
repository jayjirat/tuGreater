import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/report.dart';
import 'package:frontend/providers/comment_provider.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:frontend/providers/report_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/community/community_manage_post.dart';
import 'package:frontend/screens/community/community_me.dart';

class CommunityViewpost extends ConsumerStatefulWidget {
  final String id;
  const CommunityViewpost({super.key, required this.id});

  @override
  CommunityViewpostState createState() => CommunityViewpostState();
}

class CommunityViewpostState extends ConsumerState<CommunityViewpost> {
  bool isLiked = false;
  @override
  void initState() {
    super.initState();

    _initData();
  }

  void _initData() async {
    await ref.read(communityProvider.notifier).fetchPost(id: widget.id);
    await ref
        .read(commentProvider(widget.id).notifier)
        .fetchCommentByPostId(widget.id);
    final user = ref.read(userProvider);
    bool liked =
        await ref.read(communityProvider.notifier).isLiked(user!.id, widget.id);

    if (mounted) {
      setState(() {
        isLiked = liked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    // ignore: unused_local_variable
    final posts = ref.watch(communityProvider);
    final communityPostController = ref.read(communityProvider.notifier);
    final commentController = ref.read(commentProvider(widget.id).notifier);
    final post = communityPostController.post;
    final comments = ref.watch(commentProvider(widget.id));
    final isLoading = ref.watch(communityProvider.notifier).isLoading;

    final commentCtrl = TextEditingController();
    final commentFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLoading ? "Loading..." : post!.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CommunityMe(userId: post.userId),
                            )),
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Theme.of(context).primaryColorDark,
                              child: Icon(
                                Icons.account_circle,
                                size: 48,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                            title: Text(
                              post!.username,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  post.createdAt.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                ),
                                Text(
                                  post.isEdited ? " (edited)" : "",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                ),
                              ],
                            ),
                            trailing: post.userId == user!.id
                                ? PopupMenuButton(
                                    onSelected: (value) async {
                                      if (value == "edit") {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CommunityManagePost(
                                                mode: "Edit",
                                                post: post,
                                              ),
                                            ));
                                      } else if (value == "delete") {
                                        await communityPostController
                                            .deletePost(id: post.id);

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  )
                                : null),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Theme.of(context).cardColor,
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      post.title,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                  if (post.userId !=
                                      user.id) // owner can't report own post
                                    IconButton(
                                        onPressed: () => showReportPopup(
                                              context: context,
                                              userId: user.id,
                                              postId: post.id,
                                            ),
                                        icon: Icon(Icons.report_outlined))
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                post.description,
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 12),
                              post.imageUrl != ""
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        post.imageUrl!,
                                        fit: BoxFit.cover,
                                        // height: 200,
                                        width: double.infinity,
                                      ),
                                    )
                                  : Container(),
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
                            onTap: isLiked
                                ? () async {
                                    await communityPostController.unlikePost(
                                        user.id, post.id);
                                    setState(() {
                                      isLiked = false;
                                      post.likeCount--;
                                    });
                                  }
                                : () async {
                                    await communityPostController.likePost(
                                        user.id, post.id);
                                    setState(() {
                                      isLiked = true;
                                      post.likeCount++;
                                    });
                                  },
                            icon: isLiked
                                ? Icons.thumb_up
                                : Icons.thumb_up_alt_outlined,
                            label: "${post.likeCount}",
                          ),
                          _buildActionButton(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(commentFocusNode);
                            },
                            icon: Icons.comment_outlined,
                            label: "${post.commentCount}",
                          ),
                          _buildActionButton(
                            onTap: () {},
                            icon: Icons.cached_outlined,
                            label: "${post.repostCount}",
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // post.commentCount == 0 &&
                      comments.isEmpty
                          // comments.length == post.commentCount
                          ? Column(children: [
                              Text("No comments"),
                              const SizedBox(
                                height: 60,
                              )
                            ])
                          : Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: post.commentCount,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Theme.of(context).cardColor,
                                      margin: EdgeInsets.only(bottom: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 4,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 4),
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Theme.of(context)
                                              .primaryColorDark,
                                          child: Icon(
                                            Icons.account_circle,
                                            size: 38,
                                            color: Theme.of(context).cardColor,
                                          ),
                                        ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(comments[index].username),
                                            Text(
                                              comments[index]
                                                  .createdAt
                                                  .toString(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        subtitle: RichText(
                                          text: TextSpan(
                                              text: comments[index].content,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .canvasColor),
                                              children: [
                                                if (comments[index].userId ==
                                                    user.id)
                                                  WidgetSpan(
                                                    child: SizedBox(height: 8),
                                                  ),
                                                if (comments[index].userId ==
                                                    user.id)
                                                  TextSpan(
                                                    text: "\nDelete",
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationThickness: 2,
                                                      height: 1.5,
                                                    ),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () async {
                                                            await commentController
                                                                .deleteComment(
                                                                    widget.id,
                                                                    comments[
                                                                            index]
                                                                        .id);
                                                            setState(() {
                                                              post.commentCount--;
                                                            });
                                                          },
                                                  )
                                              ]),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
          )
        ],
      ),
      bottomSheet: isLoading
          ? null
          : Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: commentFocusNode,
                      controller: commentCtrl,
                      decoration: InputDecoration(
                        hintText: "Write a public comment...",
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      if (commentCtrl.text.isNotEmpty) {
                        await commentController.addComment(
                            postId: post!.id,
                            content: commentCtrl.text,
                            userId: user!.id,
                            username: user.displayName);

                        setState(() {
                          post.commentCount++;
                        });

                        commentCtrl.clear();
                        if (context.mounted) {
                          FocusScope.of(context).unfocus();
                        }
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.near_me,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required String label,
      required GestureTapCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(color: Theme.of(context).primaryColor)),
          ],
        ),
      ),
    );
  }

  void showReportPopup({
    required BuildContext context,
    required String userId,
    required String postId,
  }) {
    bool isChecked1 = false;
    bool isChecked2 = false;
    bool isChecked3 = false;
    bool isChecked4 = false;
    final additionalController = TextEditingController();
    List<String> reportReasons = [];
    final post = ref.read(communityProvider.notifier).post;

    showDialog(
      context: context,
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
                        setState(() {
                          isChecked1 = value!;
                          if (isChecked1) {
                            reportReasons
                                .add("Uses harsh or offensive language");
                          } else {
                            reportReasons
                                .remove("Uses harsh or offensive language");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Causes misunderstandings or confusion"),
                      value: isChecked2,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked2 = value!;
                          if (isChecked2) {
                            reportReasons
                                .add("Causes misunderstandings or confusion");
                          } else {
                            reportReasons.remove(
                                "Causes misunderstandings or confusion");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Contains inappropriate images"),
                      value: isChecked3,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked3 = value!;
                          if (isChecked3) {
                            reportReasons.add("Contains inappropriate images");
                          } else {
                            reportReasons
                                .remove("Contains inappropriate images");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text("Others"),
                      value: isChecked4,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked4 = value!;
                          if (isChecked4) {
                            reportReasons.add("Others");
                          } else {
                            reportReasons.remove("Others");
                          }
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        controller: additionalController,
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
                  onPressed: () async {
                    await ref.read(reportProvider.notifier).createReport(
                        reportReasons: reportReasons,
                        additionalInfo: additionalController.text,
                        reportedBy: userId,
                        postId: postId,
                        postCategory: PostCategory.community);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Report submitted!"),
                        ),
                      );
                    }
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
