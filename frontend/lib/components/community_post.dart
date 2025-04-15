import 'package:flutter/material.dart';
import 'package:frontend/models/com_post.dart';
import 'package:frontend/providers/community_provider.dart';

Widget communityPost(
    {required BuildContext context,
    required Widget nextRoute,
    required CommuPost post,
    required CommunityNotifier communityPostController}) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => nextRoute),
      );

      communityPostController.fetchPosts();
    },
    child: Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).primaryColorDark,
              child: Icon(
                Icons.account_circle,
                size: 36,
                color: Theme.of(context).cardColor,
              ),
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
                  post.isEdited ? " (edited)" : "",
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post.category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                        child: Image.network(
                          post.imageUrl!,
                          fit: BoxFit.cover,
                          // height: 200,
                          width: double.infinity,
                        ),
                      )
                    : Container(),
                const SizedBox(height: 10),
                Row(
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
                      icon: Icons.share_outlined,
                      label: "Share",
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
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
