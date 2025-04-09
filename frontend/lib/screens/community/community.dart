import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/community_post.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:frontend/screens/community/community_manage_post.dart';
import 'package:frontend/screens/community/community_me.dart';
import 'package:frontend/screens/community/community_view_post.dart';

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
    _initState();
  }

  void _initState() async {
    await ref.read(communityProvider.notifier).fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(communityProvider);
    final communityPostController = ref.read(communityProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF914D),
        elevation: 2,
        title: Text(
          'Community',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xFFF4F4F4)),
                ),
              ),
              onSubmitted: (value) async => await communityPostController
                  .searchPosts(searchController.text),
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
                    await communityPostController.fetchPosts();
                  } else if (currIndexToggleStatus == 1) {
                    await communityPostController.filterPosts("General");
                  } else if (currIndexToggleStatus == 2) {
                    await communityPostController.filterPosts("ReviewCourse");
                  } else if (currIndexToggleStatus == 3) {
                    await communityPostController.filterPosts("Lost%26Found");
                  }
                },
                children: [
                  toggleElement("All"),
                  toggleElement("General"),
                  toggleElement("Course Review"),
                  toggleElement("Lost & Found"),
                ]),
            const SizedBox(height: 16),
            // TODO
            //! Mock ------------------------------
            ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommunityMe(),
                      ));
                  await communityPostController.fetchPosts();
                },
                child: Text("MyProfile")),
            //! -----------------------------------
            const SizedBox(height: 16),
            Expanded(
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommunityManagePost(mode: "Add"),
              ));
        },
        backgroundColor: Color(0xFFFF914D),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget toggleElement(String text) {
    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }
}
