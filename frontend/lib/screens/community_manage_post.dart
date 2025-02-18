import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/community_provider.dart';

class CommunityManagePost extends ConsumerStatefulWidget {
  final String mode;
  final String? id;
  const CommunityManagePost({super.key, required this.mode, this.id});

  @override
  CommunityManagePostState createState() => CommunityManagePostState();
}

class CommunityManagePostState extends ConsumerState<CommunityManagePost> {
  @override
  Widget build(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  "Create a new post",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: descriptionCtrl,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  // Mock
                  decoration: InputDecoration(
                    labelText: 'Image',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Disclaimer: Posts containing inappropriate, offensive, or harmful content will be removed without prior notice. Please adhere to the community guidelines.",
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          ref.read(communityProvider.notifier).createPost(
                              title: titleCtrl.text,
                              description: descriptionCtrl.text);

                          titleCtrl.clear();
                          descriptionCtrl.clear();
                          Navigator.pop(context);
                        },
                        child: Text("Post")),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
