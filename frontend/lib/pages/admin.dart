import 'package:flutter/material.dart';
import 'ban.dart';
import 'delete_post.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        children: [
        banAccount(context),
        deletePost(context),
      ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Color(0xFFFF9000),
      title: Text(
        "Admin Control", 
        style: TextStyle(
          fontWeight: FontWeight.bold),),
      centerTitle: true,
    );
  }

  InkWell banAccount(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BanPage()),
          );
        },
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFF9000),
          ),
          child: Text(
            "Ban Account",
            style: TextStyle(fontSize: 20),
          ),
          
        ),
      );
  }

  InkWell deletePost(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeletePostPage()),
          );
        },
        child: Container(
          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
          height: 150,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFF9000),
          ),
          child: Text(
            "Delete Post",
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
  }
}