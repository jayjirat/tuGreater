import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/community_post.dart';
import 'package:frontend/providers/community_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/community/community_view_post.dart';

class CommunityMe extends ConsumerStatefulWidget {
  const CommunityMe({super.key});

  @override
  CommunityMeState createState() => CommunityMeState();
}

class CommunityMeState extends ConsumerState<CommunityMe> {
  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    Future.microtask(() async {
      final user = ref.read(userProvider);
      await ref.read(communityProvider.notifier).fetchMyPosts(user!.studentId);
    });
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(communityProvider);
    final communityPostController = ref.read(communityProvider.notifier);
    final List<Widget> swapPage = [
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
      Text("shop")
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF914D),
        elevation: 2,
        title: Text(
          'My Community Posts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 52,
              backgroundColor: Color(0xFFFF914D),
              child: Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Jirat Charoenkaew", //username
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Jayeieie", //displayname
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black38),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    spreadRadius: 1,
                    blurRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  swapBar(
                      text: "Posts",
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                      },
                      selectedIndex: 0),
                  const SizedBox(
                    width: 4,
                  ),
                  swapBar(
                      text: "Shops",
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                      selectedIndex: 1),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            swapPage[_selectedIndex]
          ],
        ),
      ),
    );
  }

  Widget swapBar(
      {required String text,
      required GestureTapCallback onPressed,
      required int selectedIndex}) {
    return Expanded(
        child: TextButton(
      onPressed: onPressed,
      style: _selectedIndex == selectedIndex
          ? activeSwapBarStyle()
          : inactiveSwapBarStyle(),
      child: Text(text),
    ));
  }

  ButtonStyle inactiveSwapBarStyle() {
    return TextButton.styleFrom(
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      foregroundColor: Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  ButtonStyle activeSwapBarStyle() {
    return TextButton.styleFrom(
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      backgroundColor: Colors.black.withValues(alpha: 0.08),
      foregroundColor: Color(0xFFFF914D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
