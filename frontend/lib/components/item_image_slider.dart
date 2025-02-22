import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ItemImageSlider extends StatelessWidget {
  const ItemImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      // Ensures images respect the container's border radius
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: ImageSlideshow(
        indicatorColor: Colors.white,
        indicatorBackgroundColor: Colors.black26,
        height: MediaQuery.of(context).size.height /
            2, // Matches parent container height
        autoPlayInterval: 3000,
        indicatorRadius: 4,
        isLoop: true,
        children: [
          Image.asset(
            'assets/images/shoe.jpg',
            width: double.infinity, // Ensures full width usage
            fit: BoxFit.cover, // Makes image fit the box
          ),
          Image.asset(
            'assets/images/shoe.jpg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/shoe.jpg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/images/shoe.jpg',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
