import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/filter_modal.dart';
import 'package:frontend/components/grid_items.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/shop/add_items.dart';

class Shop extends ConsumerStatefulWidget {
  const Shop({super.key});

  @override
  ConsumerState<Shop> createState() => _ShopState();
}

class _ShopState extends ConsumerState<Shop> {
  bool isClicked = false;
  var iconCategoriesList = [
    'assets/svg/food.svg',
    'assets/svg/drink.svg',
    'assets/svg/clothes.svg',
    'assets/svg/dormitory.svg',
    'assets/svg/others.svg'
  ];

  String searchQuery = "";
  int selectedCategory = -1;

  double? minPrice;
  double? maxPrice;
  bool isCheckedHighToLowPrice = false;
  bool isCheckedLowToHighPrice = false;
  bool isCheckedNewFirst = false;
  bool isCheckedOldFirst = false;
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 15,
      ),
      Row(
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          Expanded(
            flex: 5,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
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
              onTap: () async {
                setState(() {
                  isClicked = !isClicked;
                });

                final filterData = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return FilterModal(
                      minPrice: minPrice,
                      maxPrice: maxPrice,
                      isCheckedHighToLowPrice: isCheckedHighToLowPrice,
                      isCheckedLowToHighPrice: isCheckedLowToHighPrice,
                      isCheckedNewFirst: isCheckedNewFirst,
                      isCheckedOldFirst: isCheckedOldFirst,
                      isCheckedFirstHanded: selectedTags.contains('มือหนึ่ง'),
                      isCheckedSecondHanded: selectedTags.contains('มือสอง'),
                      isCheckedGood: selectedTags.contains('สภาพดี'),
                      isCheckedDelicious: selectedTags.contains('อร่อย'),
                      isCheckedClean: selectedTags.contains('สะอาด'),
                      selectedTags: selectedTags,
                    );
                  },
                );

                if (filterData != null) {
                  setState(() {
                    minPrice = filterData['minPrice'];
                    maxPrice = filterData['maxPrice'];
                    isCheckedHighToLowPrice =
                        filterData['isCheckedHighToLowPrice'];
                    isCheckedLowToHighPrice =
                        filterData['isCheckedLowToHighPrice'];
                    isCheckedNewFirst = filterData['isCheckedNewFirst'];
                    isCheckedOldFirst = filterData['isCheckedOldFirst'];
                    selectedTags =
                        List<String>.from(filterData['selectedTags'] ?? []);
                  });
                }

                setState(() {
                  isClicked = false;
                });
              },
              child: SvgPicture.asset(
                "assets/svg/filter.svg",
                height: 40,
                width: 40,
                colorFilter: ColorFilter.mode(
                  isClicked
                      ? const Color.fromARGB(255, 243, 221, 19)
                      : Colors.black,
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
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = -1;
                  });
                },
                child: Container(
                  // ช่องสี่เหลี่ยม for "All"
                  height: 45,
                  width: 48,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selectedCategory == -1
                        ? Colors.white
                        : Color.fromARGB(255, 254, 227, 121),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: Center(
                      child: Text("All",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
            for (var i = 0; i < 5; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = i;
                    });
                  },
                  child: Container(
                    // ช่องสี่เหลี่ยม for categories
                    height: 45,
                    width: 48,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selectedCategory == i
                          ? Colors.white
                          : Color.fromARGB(255, 254, 227, 121),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: SvgPicture.asset(iconCategoriesList[i]),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      SizedBox(
        height: 15,
      ),
      GridItems(
          searchQuery: searchQuery,
          selectedCategory: selectedCategory,
          minPrice: minPrice,
          maxPrice: maxPrice,
          isCheckedHighToLowPrice: isCheckedHighToLowPrice,
          isCheckedLowToHighPrice: isCheckedLowToHighPrice,
          isCheckedNewFirst: isCheckedNewFirst,
          isCheckedOldFirst: isCheckedOldFirst,
          selectedTags: selectedTags),
    ]);
  }
}
