import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/filter_modal.dart';
import 'package:frontend/components/grid_items.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                hintText: AppLocalizations.of(context)!.shop_search,
                suffixIcon: Icon(Icons
                    .search), // Search icon on the right         // Light background for input
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
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).canvasColor,
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
            SizedBox(
              width: 90,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = -1;
                  });
                },
                child: Container(
                  height: 45,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selectedCategory == -1
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.shop_category,
                      style: TextStyle(
                        fontSize: 18,
                        color: selectedCategory == -1
                            ? Theme.of(context).cardColor
                            : Theme.of(context).canvasColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Other categories
            for (var i = 0; i < 5; i++)
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = i;
                    });
                  },
                  child: Container(
                    height: 45,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selectedCategory == i
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).cardColor,
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
                      child: SvgPicture.asset(
                        iconCategoriesList[i],
                        color: selectedCategory == i
                            ? Theme.of(context).cardColor
                            : Theme.of(context).canvasColor,
                      ),
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
