import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/com_post.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget communityPost(
    {required BuildContext context,
    required Widget nextRoute,
    required CommuPost post,
    required CommunityNotifier communityPostController,
    required bool isfromProfile,
    required String userId}) {
  return postCard(
      context: context,
      post: post,
      communityPostController: communityPostController,
      isfromProfile: isfromProfile,
      nextRoute: nextRoute,
      userId: userId);
}

Widget postCard({
  required BuildContext context,
  required CommuPost post,
  required CommunityNotifier communityPostController,
  required bool isfromProfile,
  required Widget nextRoute,
  required String userId,
}) {
  return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextRoute),
        );
        // if (!isfromProfile) {
        //   if (context.mounted) {
        //     communityPostController.fetchPosts(context: context);
        //   }
        // }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.isReposted)
            Row(
              children: [
                Icon(Icons.repeat_outlined, color: Colors.grey[600]),
                post.repostedUserId == userId
                    ? Text(
                        "${AppLocalizations.of(context)!.you}${AppLocalizations.of(context)!.reposted}")
                    : Text(
                        "${post.repostedUsername} ${AppLocalizations.of(context)!.reposted}"),
              ],
            ),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Theme.of(context).cardColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: post.postedByImageUrl == "" ||
                          post.postedByImageUrl == null
                      ? CircleAvatar(
                          radius:
                              MediaQuery.of(context).size.width > 360 ? 24 : 20,
                          backgroundColor: Theme.of(context).primaryColorDark,
                          child: Icon(
                            Icons.account_circle,
                            size: MediaQuery.of(context).size.width > 360
                                ? 48
                                : 40,
                            color: Theme.of(context).cardColor,
                          ),
                        )
                      : CircleAvatar(
                          radius:
                              MediaQuery.of(context).size.width > 360 ? 24 : 20,
                          backgroundImage: CachedNetworkImageProvider(post.postedByImageUrl!),
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
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        post.isEdited
                            ? " (${AppLocalizations.of(context)!.edit})"
                            : "",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              getLocalizedCategory(post.category, context),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (post.description != "") const SizedBox(height: 10),
                      if (post.description != "")
                        Text(
                          post.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 10),
                      post.imageUrl != ""
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                useOldImageOnUrlChange: true,
                                fadeInDuration: Duration.zero,
                                imageUrl: post.imageUrl!,
                                fit: BoxFit.cover,
                                // height: 200,
                                width: double.infinity,
                                placeholder: (context, url) => SizedBox(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            )
                          : Container(),
                      const SizedBox(height: 10),
                      if (!post.isReposted)
                        actionButtons(context: context, post: post)
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ));
}

Widget actionButtons({required BuildContext context, required CommuPost post}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      buildActionButton(
        context: context,
        icon: Icons.thumb_up_alt_outlined,
        label: "${post.likeCount}",
      ),
      buildActionButton(
        context: context,
        icon: Icons.comment_outlined,
        label: "${post.commentCount}",
      ),
      buildActionButton(
        context: context,
        icon: Icons.repeat_outlined,
        label: "${post.repostCount}",
      ),
    ],
  );
}

String getLocalizedCategory(String category, BuildContext context) {
  if (category == "All") {
    return AppLocalizations.of(context)!.all;
  } else if (category == "General") {
    return AppLocalizations.of(context)!.general;
  } else if (category == "ReviewCourse") {
    return AppLocalizations.of(context)!.courseReview;
  } else if (category == "Lost&Found") {
    return AppLocalizations.of(context)!.lostNfound;
  } else {
    return category;
  }
}

Widget buildActionButton(
    {required IconData icon,
    required String label,
    required BuildContext context}) {
  return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Theme.of(context).primaryColor)),
        ],
      ));
}
