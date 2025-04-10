import 'package:flutter/material.dart';
import 'package:frontend/screens/profile/image_picker.dart';
import 'package:frontend/components/custom_bottom_navigation.dart';

class UploadProfilePage extends StatefulWidget {
  const UploadProfilePage({super.key});

  @override
  State<UploadProfilePage> createState() => _UploadProfilePageState();
}

class _UploadProfilePageState extends State<UploadProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
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
                    Text(
                      "Name Surname",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      "65106150888",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
              ),
            ),
            Center(
                child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color
                minimumSize: Size(350, 75),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text("Return to default picture",
                  style: TextStyle(color: Colors.black, fontSize: 20)),
            )),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
