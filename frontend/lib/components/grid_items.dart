import 'package:flutter/material.dart';
import 'package:frontend/pages/item_detail.dart';

class GridItems extends StatelessWidget {
  const GridItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: 10,
        physics: AlwaysScrollableScrollPhysics(), // Enable scrolling
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.715,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(10),
            child: Material(
              color: Colors
                  .transparent, // Make the material transparent so it only affects the BoxDecoration area
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ItemDetail()));
                }, // navigate to items detail
                borderRadius: BorderRadius.circular(
                    15), // Match the border radius of BoxDecoration
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 254, 227, 121),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          spreadRadius: 2),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
