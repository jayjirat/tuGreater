import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/models/role.dart';

Widget customBottomNavigationBar({
  required int currentIndex,
  required ValueChanged<int> onTap,
  required BuildContext context,
  required WidgetRef ref,
  }) {

  final user = ref.watch(userProvider);
  final isAdmin = user?.role == Role.admin;
  print(user?.role);

  final items = [
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
  ];

  if (isAdmin) {
    items.insert(
      3,
      BottomNavigationBarItem(
        icon: Icon(Icons.admin_panel_settings),
        label: 'Admin',
      ),
    );
  }

  return BottomNavigationBar(
    items: items,
    currentIndex: currentIndex,
    onTap: onTap,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    backgroundColor: Theme.of(context).cardColor,
    selectedItemColor:
        Theme.of(context).primaryColor, // Set the selected icon color to yellow
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
  );
}


// CustomBottomNavigationBar
