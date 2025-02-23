import "package:flutter/material.dart";
import "package:frontend/imagetext_container.dart";

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return imagetext_container(
      imageUrl:
          "https://static.vecteezy.com/system/resources/previews/020/765/399/non_2x/default-profile-account-unknown-icon-black-silhouette-free-vector.jpg",
      text: "Name Surname",
      containerWidth: 350,
      containerHeight: 150,
      imageWidth: 50,
      spacing: 16,
    );
  }
}
