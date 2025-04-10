import 'package:flutter/material.dart';

class DeletePostPage extends StatelessWidget {
  const DeletePostPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Color(0xFFFF9000),
      title: Text(
        "Delete Post", 
        style: TextStyle(
          fontWeight: FontWeight.bold),),
      centerTitle: true,
    );
  }
}