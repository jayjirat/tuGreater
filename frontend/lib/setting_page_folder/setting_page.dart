import 'package:flutter/material.dart';
import 'package:frontend/setting_page_folder/single_toggle_buttons.dart';
import 'package:frontend/components/custom_bottom_navigation.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int selectedLanguage = 0; // 0 = English, 1 = Thai
  int selectedTheme = 0; // 0 = Light, 1 = Dark

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
                  height: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(
                        "https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg",
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                    ],
                  )),
            ),
            // Language Selection
            Text(
              "Language",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            CustomToggle(
              options: ["English", "Thai"],
              selectedIndex: selectedLanguage,
              onChanged: (index) {
                setState(() {
                  selectedLanguage = index;
                });
              },
            ),
            // Theme Selection
            Text(
              "Theme",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            CustomToggle(
              options: ["Light", "Dark"],
              selectedIndex: selectedTheme,
              onChanged: (index) {
                setState(() {
                  selectedTheme = index;
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
