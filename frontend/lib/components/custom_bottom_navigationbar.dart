import 'package:flutter/material.dart';

Widget customBottomNavigationBar(
    {required int currentIndex,
    required ValueChanged<int> onTap,
    required BuildContext context}) {
  return BottomNavigationBar(
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.group),
        label: 'Community',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_bag),
        label: 'Shop',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle),
        label: 'Profile',
      ),
    ],
    currentIndex: currentIndex,
    onTap: onTap,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    backgroundColor: Theme.of(context).cardColor,
    selectedItemColor:
        Theme.of(context).primaryColor, // Set the selected icon color to yellow
  );
}

// CustomBottomNavigationBar
