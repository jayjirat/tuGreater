import 'package:flutter/material.dart';
import 'package:frontend/test_page.dart';

class UploadProfilePage extends StatefulWidget {
  const UploadProfilePage({super.key});

  @override
  State<UploadProfilePage> createState() => _UploadProfilePageState();
}

class _UploadProfilePageState extends State<UploadProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 130, 9),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.all(10),
                width: 350,
                height: 400,
                child: Column(
                  children: [
                    ProfileImagePicker(
                        existingImageUrl:
                            "https://picsum.photos/id/237/200/300"),
                    Text(
                      "Name Surname",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    Text(
                      "65106150888",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: 160,
                    height: 75,
                    child: Center(
                        child: Text(
                      "Select",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ))),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: 160,
                    height: 75,
                    child: Center(
                        child: Text(
                      "Upload",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ))),
              ],
            ),
            Center(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    width: 350,
                    height: 75,
                    child: Center(
                        child: Text(
                      "Delete profile image",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )))),
          ],
        ),
      ),
      // to be implement
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text("Bottom Navigation"),
        ),
      ),
    );
  }
}
