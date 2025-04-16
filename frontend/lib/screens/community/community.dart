import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/community_post.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:frontend/screens/community/community_view_post.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/screens/error_page.dart';

class Community extends ConsumerStatefulWidget {
  const Community({super.key});

  @override
  CommunityState createState() => CommunityState();
}

class CommunityState extends ConsumerState<Community> {
  final searchController = TextEditingController();

  List<bool> toggleStatus = [
    true,
    false,
    false,
    false,
  ];
  int currIndexToggleStatus = 0;

  @override
  void initState() {
    super.initState();
    tryFetchPosts();
  }

  Future<void> tryFetchPosts() async {
    try {
      await ref.read(communityProvider.notifier).fetchPosts(context: context);
    } catch (e) {
      toErrorPage(message: e.toString());
    }
  }

  Future<void> tryFilterPosts({required String category}) async {
    try {
      await ref
          .read(communityProvider.notifier)
          .filterPosts(category: category, context: context);
    } catch (e) {
      toErrorPage(message: e.toString());
    }
  }

  void toErrorPage({required String message}) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorPage(errorMessage: message),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(communityProvider);
    final communityPostController = ref.read(communityProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchPost,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
            onSubmitted: (value) async {
              try {
                await communityPostController.searchPosts(
                    query: searchController.text, context: context);
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
            },
          ),
          const SizedBox(height: 16),
          ToggleButtons(
              isSelected: toggleStatus,
              borderRadius: BorderRadius.circular(30),
              onPressed: (index) async {
                setState(() {
                  toggleStatus[index] = true;
                  toggleStatus[currIndexToggleStatus] = false;
                  currIndexToggleStatus = index;
                });

                if (currIndexToggleStatus == 0) {
                  await tryFetchPosts();
                } else if (currIndexToggleStatus == 1) {
                  await tryFilterPosts(category: "General");
                } else if (currIndexToggleStatus == 2) {
                  await tryFilterPosts(category: "ReviewCourse");
                } else if (currIndexToggleStatus == 3) {
                  await tryFilterPosts(category: "Lost%26Found");
                }
              },
              children: [
                toggleElement("All"),
                toggleElement("General"),
                toggleElement("Course Review"),
                toggleElement("Lost & Found"),
              ]),
          const SizedBox(height: 16),
          posts.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          communityPost(
                              context: context,
                              nextRoute: CommunityViewpost(id: post.id),
                              post: post,
                              communityPostController: communityPostController),
                          const SizedBox(height: 12),
                        ],
                      );
                    },
                  ),
                )
              : Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        size: 120,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 32),
                      Text(
                        AppLocalizations.of(context)!.noPosts,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.noPostsContent,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  String getLocalizedCategory(String category) {
    if (category == "All") {
      return AppLocalizations.of(context)!.all;
    } else if (category == "General") {
      return AppLocalizations.of(context)!.general;
    } else if (category == "Course Review") {
      return AppLocalizations.of(context)!.courseReview;
    } else if (category == "Lost & Found") {
      return AppLocalizations.of(context)!.lostNfound;
    } else {
      return category;
    }
  }

  Widget toggleElement(String text) {
    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        Text(
          getLocalizedCategory(text),
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
