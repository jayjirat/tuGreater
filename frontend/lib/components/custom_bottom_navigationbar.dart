import 'package:flutter/material.dart';

Widget customBottomNavigationBar({required int currentIndex,required ValueChanged<int> onTap}) {
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
      backgroundColor: Colors.white,
      selectedItemColor: const Color.fromARGB(
          255, 255, 147, 7), // Set the selected icon color to yellow
    );
}

// CustomBottomNavigationBar
