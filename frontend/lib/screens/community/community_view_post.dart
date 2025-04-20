import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/toast.dart';
import 'package:frontend/models/report.dart';
import 'package:frontend/providers/comment_provider.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:frontend/providers/report_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/community/community_manage_post.dart';
import 'package:frontend/screens/community/community_me.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/screens/error_page.dart';

class CommunityViewpost extends ConsumerStatefulWidget {
  final String id;
  const CommunityViewpost({super.key, required this.id});

  @override
  CommunityViewpostState createState() => CommunityViewpostState();
}

class CommunityViewpostState extends ConsumerState<CommunityViewpost> {
  bool isLiked = false;
  bool isReposted = false;
  @override
  void initState() {
    super.initState();

    _initData();
  }

  void _initData() async {
    try {
      await ref
          .read(communityProvider.notifier)
          .fetchPost(id: widget.id, context: context);
      await ref
          .read(commentProvider(widget.id).notifier)
          .fetchCommentByPostId(widget.id);
      final user = ref.read(userProvider);
      bool liked = await ref
          .read(communityProvider.notifier)
          .isLiked(userId: user!.id, postId: widget.id, context: context);
      bool reposted = await ref
          .read(communityProvider.notifier)
          .isReposted(userId: user.id, postId: widget.id, context: context);

      if (mounted) {
        setState(() {
          isLiked = liked;
          isReposted = reposted;
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(errorMessage: e.toString()),
            ));
      }
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
          isLoading ? AppLocalizations.of(context)!.loading : post!.title,
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
                            leading: post!.postedByImageUrl == ""
                                ? CircleAvatar(
                                    radius: 18,
                                    backgroundColor:
                                        Theme.of(context).primaryColorDark,
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 36,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 28,
                                    backgroundImage:
                                        NetworkImage(post.postedByImageUrl!),
                                    backgroundColor: Colors.transparent,
                                  ),
                            title: Text(
                              post.username,
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
                                  post.isEdited
                                      ? " (${AppLocalizations.of(context)!.edit})"
                                      : "",
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
                                        try {
                                          await communityPostController
                                              .deletePost(
                                                  id: post.id,
                                                  context: context,
                                                  isRepost: false);
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            showToast(
                                              message:
                                                  AppLocalizations.of(context)!
                                                      .postDeletedSuccess,
                                              toastType: ToastType.success,
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ErrorPage(
                                                          errorMessage:
                                                              e.toString()),
                                                ));
                                          }
                                        }
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem<String>(
                                        value: 'edit',
                                        child: Text(
                                            AppLocalizations.of(context)!.edit),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'delete',
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .delete),
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
                                              studentId: user.studentId,
                                              postId: post.id,
                                            ),
                                        icon: Icon(Icons.report_outlined))
                                ],
                              ),
                              if (post.description != "")
                                const SizedBox(height: 4),
                              if (post.description != "")
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
                                    try {
                                      await communityPostController.unlikePost(
                                          userId: user.id,
                                          postId: post.id,
                                          context: context);
                                      setState(() {
                                        isLiked = false;
                                        post.likeCount--;
                                      });
                                    } catch (e) {
                                      if (context.mounted) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ErrorPage(
                                                  errorMessage: e.toString()),
                                            ));
                                      }
                                    }
                                  }
                                : () async {
                                    try {
                                      await communityPostController.likePost(
                                          userId: user.id,
                                          postId: post.id,
                                          context: context);
                                      setState(() {
                                        isLiked = true;
                                        post.likeCount++;
                                      });
                                    } catch (e) {
                                      if (context.mounted) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ErrorPage(
                                                  errorMessage: e.toString()),
                                            ));
                                      }
                                    }
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
                            onTap: (post.userId != user.id)
                                ? (post.isReposted
                                    ? () {
                                        showToast(
                                            message:
                                                AppLocalizations.of(context)!
                                                    .cannotRepostedPost,
                                            toastType: ToastType.info);
                                      }
                                    : (isReposted
                                        ? () async {
                                            await communityPostController
                                                .deletePost(
                                                    id: post.id,
                                                    context: context,
                                                    isRepost: true);
                                            setState(() {
                                              isReposted = false;
                                              post.repostCount--;
                                            });
                                          }
                                        : () async {
                                            await communityPostController
                                                .createPost(
                                                    title: post.title,
                                                    description:
                                                        post.description,
                                                    category: post.category,
                                                    userId: post.userId,
                                                    username: post.username,
                                                    imageUrl: post.imageUrl,
                                                    postedByImageUrl:
                                                        post.postedByImageUrl ??
                                                            "",
                                                    isReposted: true,
                                                    repostedUserId: user.id,
                                                    repostedPostId: post.id,
                                                    repostedUsername:
                                                        user.displayName,
                                                    context: context);
                                            setState(() {
                                              isReposted = true;
                                              post.repostCount++;
                                            });
                                          }))
                                : () {
                                    showToast(
                                        message: AppLocalizations.of(context)!
                                            .cannotRepostOwnPost,
                                        toastType: ToastType.info);
                                  },
                            icon: isReposted
                                ? Icons.repeat_on_outlined
                                : Icons.repeat_outlined,
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
                              Text(AppLocalizations.of(context)!.noComment),
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
                                        leading: comments[index]
                                                    .commentedByImageUrl ==
                                                ""
                                            ? CircleAvatar(
                                                radius: 20,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .primaryColorDark,
                                                child: Icon(
                                                  Icons.account_circle,
                                                  size: 38,
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    comments[index]
                                                        .commentedByImageUrl!),
                                                backgroundColor:
                                                    Colors.transparent,
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
                                                    text:
                                                        "\n${AppLocalizations.of(context)!.delete}",
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
                                                            try {
                                                              await commentController
                                                                  .deleteComment(
                                                                      widget.id,
                                                                      comments[
                                                                              index]
                                                                          .id);
                                                              setState(() {
                                                                post.commentCount--;
                                                              });
                                                              if (context
                                                                  .mounted) {
                                                                showToast(
                                                                  message: AppLocalizations.of(
                                                                          context)!
                                                                      .commentDeletedSuccess,
                                                                  toastType:
                                                                      ToastType
                                                                          .success,
                                                                );
                                                              }
                                                            } catch (e) {
                                                              if (context
                                                                  .mounted) {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ErrorPage(
                                                                              errorMessage: e.toString()),
                                                                    ));
                                                              }
                                                            }
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
                        hintText: AppLocalizations.of(context)!.writeComment,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      if (commentCtrl.text.isNotEmpty) {
                        try {
                          await commentController.addComment(
                              postId: post!.id,
                              content: commentCtrl.text,
                              userId: user!.id,
                              username: user.displayName,
                              commentedByImageUrl: user.profileImageUrl);

                          setState(() {
                            post.commentCount++;
                          });

                          commentCtrl.clear();
                          if (context.mounted) {
                            FocusScope.of(context).unfocus();
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ErrorPage(errorMessage: e.toString()),
                                ));
                          }
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
    required String studentId,
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
                "${AppLocalizations.of(context)!.reportPost} ${post!.title}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title:
                          Text(AppLocalizations.of(context)!.commuReportTopic1),
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
                      title:
                          Text(AppLocalizations.of(context)!.commuReportTopic2),
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
                      title:
                          Text(AppLocalizations.of(context)!.commuReportTopic3),
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
                      title:
                          Text(AppLocalizations.of(context)!.commuReportTopic4),
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
                          hintText: AppLocalizations.of(context)!.description,
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
                  child: Text(AppLocalizations.of(context)!.cancel),
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
                        reportedBy: studentId,
                        postId: postId,
                        postCategory: PostCategory.community);
                    if (context.mounted) {
                      Navigator.pop(context);
                      showToast(
                        message: AppLocalizations.of(context)!
                            .reportSubmittedSuccess,
                        toastType: ToastType.success,
                      );
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.report),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
