import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/community_provider.dart';

class CommunityViewpost extends ConsumerStatefulWidget {
  final String id;
  final String username = "Jirat Charoenkaew";
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        size: 50,
                      ),
                      title: Text(widget.username),
                      subtitle: Text(post!.createdAt.toString()),
                      trailing: Icon(Icons.report_problem),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          post.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(post.description),
                        const SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "https://fastly.picsum.photos/id/67/200/200.jpg?hmac=sN5XCCMqqmBvgDbYmAowWy2VToCkSYP5igDL_iRxK3M",
                            fit: BoxFit.cover,
                            scale: 10.0,
                            // ยิ่งค่ามากยิ่งเล็กลง
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {},
                                child: Icon(Icons.thumb_up_alt_outlined)),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("${post.likeCount}")
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {},
                                child: Icon(Icons.comment_outlined)),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("${post.comments.length}")
                          ],
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.share_outlined),
                              const SizedBox(
                                width: 5,
                              ),
                              Text("Share")
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      children: post.comments.isEmpty
                          ? [Text("No comments")]
                          : [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: post.comments.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: Icon(
                                      Icons.account_circle,
                                      size: 50,
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
                                        )
                                      ],
                                    ),
                                    subtitle: Text(post.comments[index].text),
                                  );
                                },
                              ),
                            ],
                    )
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.near_me, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
