import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:frontend/screens/community/community_manage_post.dart';
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
    ref.read(communityProvider.notifier).fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(communityProvider);
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
              onSubmitted: (value) => ref
                  .read(communityProvider.notifier)
                  .searchPosts(searchController.text),
            ),
            const SizedBox(height: 16),
            ToggleButtons(
                isSelected: toggleStatus,
                borderRadius: BorderRadius.circular(30),
                onPressed: (index) {
                  setState(() {
                    toggleStatus[index] = true;
                    toggleStatus[currIndexToggleStatus] = false;
                    currIndexToggleStatus = index;
                  });

                  if (currIndexToggleStatus == 0) {
                    ref.read(communityProvider.notifier).fetchPosts();
                  } else if (currIndexToggleStatus == 1) {
                    ref.read(communityProvider.notifier).filterPosts("General");
                  } else if (currIndexToggleStatus == 2) {
                    ref
                        .read(communityProvider.notifier)
                        .filterPosts("ReviewCourse");
                  } else if (currIndexToggleStatus == 3) {
                    ref
                        .read(communityProvider.notifier)
                        .filterPosts("Lost%26Found");
                  }
                },
                children: [
                  toggleElement("All"),
                  toggleElement("General"),
                  toggleElement("Course Review"),
                  toggleElement("Lost & Found"),
                ]),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CommunityViewpost(id: post.id)));
                        },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Color(0xFFFF914D),
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  post.username,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  post.createdAt.toString(),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
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
