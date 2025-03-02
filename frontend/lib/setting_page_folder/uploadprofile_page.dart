import 'package:flutter/material.dart';
import 'package:frontend/setting_page_folder/image_picker.dart';

class UploadProfilePage extends StatefulWidget {
  const UploadProfilePage({super.key});

  @override
  State<UploadProfilePage> createState() => _UploadProfilePageState();
}

class _UploadProfilePageState extends State<UploadProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 112, 9),
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
                height: 500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfileImagePicker(
                        existingImageUrl:
                            "https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg"),
                    SizedBox(height: 20),
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
                      "Return to default profile picture",
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
