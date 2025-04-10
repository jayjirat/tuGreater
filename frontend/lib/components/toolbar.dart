import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const Toolbar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 255, 147, 7),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
