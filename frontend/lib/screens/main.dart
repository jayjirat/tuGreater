import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/custom_bottom_navigationbar.dart';
import 'package:frontend/screens/community/community.dart';
import 'package:frontend/screens/community/community_manage_post.dart';
import 'package:frontend/screens/profile/profile_page.dart';
import 'package:frontend/screens/shop/add_items.dart';
import 'package:frontend/screens/shop/shop.dart';
import 'package:frontend/screens/admin/admin.dart';

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  @override
  MainState createState() => MainState();
}

class MainState extends ConsumerState<Main> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final screens = [
      Community(), 
      Shop(), 
      ProfilePage(),
      AdminPage(),
      ];

    return Scaffold(
      body: SafeArea(child: screens[currentIndex]),
      bottomNavigationBar: customBottomNavigationBar(
          currentIndex: currentIndex,
          context: context,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          ref: ref,
          ),
      floatingActionButton: (currentIndex == 0 || currentIndex == 1)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    if (currentIndex == 0) {
                      return CommunityManagePost(mode: "Add");
                    } else {
                      return AddItems();
                    }
                  },
                ));
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
