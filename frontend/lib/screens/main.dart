import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/custom_bottom_navigationbar.dart';
import 'package:frontend/screens/community/community.dart';
import 'package:frontend/screens/profile/profile_page.dart';
import 'package:frontend/screens/shop/shop.dart';

class Main extends ConsumerStatefulWidget {
  const Main({super.key});

  @override
  MainState createState() => MainState();
}

class MainState extends ConsumerState<Main> {
  int currentIndex = 0;
  final screens = [Community(), Shop(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: customBottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          }),
    );
  }
}
