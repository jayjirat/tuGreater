import 'package:flutter/material.dart';
import 'package:frontend/components/filter_modal.dart';
import 'package:frontend/components/grid_items.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/pages/add_items.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  bool isClicked = false;
  var iconCategoriesList = [
    'assets/svg/food.svg',
    'assets/svg/drink.svg',
    'assets/svg/clothes.svg',
    'assets/svg/dormitory.svg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: "Shop"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddItems()));
        }, // navigate to add items page
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
              Expanded(
                flex: 5,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    suffixIcon: Icon(Icons.search), // Search icon on the right
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200], // Light background for input
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isClicked = !isClicked; // Toggle color on click
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, // Allow dynamic height
                          builder: (context) {
                            return FilterModal();
                          }).whenComplete(() {
                        // Reset the filter icon color when the modal is closed (dismissed)
                        setState(() {
                          isClicked = false; // Reset to original color (black)
                        });
                      });
                    });
                  },
                  child: SvgPicture.asset(
                    "assets/svg/filter.svg",
                    height: 40,
                    width: 40,
                    colorFilter: ColorFilter.mode(
                      isClicked
                          ? const Color.fromARGB(255, 243, 221, 19)
                          : Colors.black, // Change color
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          SingleChildScrollView(
            // Tag
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(left: 5), //ที่ว่างขอบจอซ้าย
              child: Row(
                children: [
                  for (var i = 0; i < 4; i++)
                    Container(
                      //ช่องสี่เหลี่ยม
                      height: 43,
                      width: 48,
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 254, 227, 121),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              spreadRadius: 2,
                            )
                          ]),
                      child: Padding(
                          padding: EdgeInsets.all(6),
                          child: SvgPicture.asset(iconCategoriesList[i])),
                    )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GridItems(),
        ],
      ),
    );
  }
}
