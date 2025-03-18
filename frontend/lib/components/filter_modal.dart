import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  bool isCheckedFirstHanded = false;
  bool isCheckedSecondHanded = false;
  bool isCheckedGood = false;
  bool isCheckedDelicious = false;
  bool isCheckedClean = false;
  bool isCheckedHighToLowPrice = false;
  bool isCheckedLowToHighPrice = false;
  bool isCheckedNewFirst = false;
  bool isCheckedOldFirst = false;
  double? minPrice;
  double? maxPrice;

  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      padding: EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.center, // Align to the left or center
        child: Column(
          children: [
            Text(
              "Filter Product",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "ราคาต่ำสุด",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 100,
                ),
                Text(
                  "ราคาสูงสุด",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 150,
                  child: TextField(
                    keyboardType:
                        TextInputType.number, // Set keyboard to number
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Allow only numbers
                    decoration: InputDecoration(
                      hintText: "Low",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      minPrice = double.tryParse(value);
                    },
                  ),
                ),
                SizedBox(
                  width: 38,
                  child: Center(
                      child: Text(
                    "-",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                ),
                SizedBox(
                  width: 150,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ], // Allow only numbers
                    decoration: InputDecoration(
                      hintText: "High",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onChanged: (value) {
                      maxPrice = double.tryParse(value);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "Tag",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                // First checkbox with fixed text
                Row(
                  children: [
                    Checkbox(
                      value: isCheckedFirstHanded,
                      onChanged: (value) {
                        setState(() {
                          isCheckedFirstHanded = value!;
                          if (value == true) {
                            selectedTags.add("มือหนึ่ง");
                          } else {
                            selectedTags.remove("มือหนึ่ง");
                          }
                        });
                      },
                    ),
                    Text("มือหนึ่ง"),
                  ],
                ),
                SizedBox(width: 10),

                // Second checkbox with fixed text
                Row(
                  children: [
                    Checkbox(
                      value: isCheckedSecondHanded,
                      onChanged: (value) {
                        setState(() {
                          isCheckedSecondHanded = value!;
                          if (value == true) {
                            selectedTags.add("มือสอง");
                          } else {
                            selectedTags.remove("มือสอง");
                          }
                        });
                      },
                    ),
                    Text("มือสอง"),
                  ],
                ),
                SizedBox(width: 10),
                Row(
                  children: [
                    Checkbox(
                      value: isCheckedGood,
                      onChanged: (value) {
                        setState(() {
                          isCheckedGood = value!;
                          if (value == true) {
                            selectedTags.add("สภาพดี");
                          } else {
                            selectedTags.remove("สภาพดี");
                          }
                        });
                      },
                    ),
                    Text("สภาพดี"),
                  ],
                ),
                SizedBox(width: 10),
              ],
            ),
            Row(
              children: [
                // First checkbox with fixed text
                Row(
                  children: [
                    Checkbox(
                      value: isCheckedDelicious,
                      onChanged: (value) {
                        setState(() {
                          isCheckedDelicious = value!;
                          if (value == true) {
                            selectedTags.add("อร่อย");
                          } else {
                            selectedTags.remove("อร่อย");
                          }
                        });
                      },
                    ),
                    Text("อร่อย"),
                  ],
                ),
                SizedBox(width: 19),

                // Second checkbox with fixed text
                Row(
                  children: [
                    Checkbox(
                      value: isCheckedClean,
                      onChanged: (value) {
                        setState(() {
                          isCheckedClean = value!;
                          if (value == true) {
                            selectedTags.add("สะอาด");
                          } else {
                            selectedTags.remove("สะอาด");
                          }
                        });
                      },
                    ),
                    Text("สะอาด"),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "เรียงสินค้า",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        if (isCheckedHighToLowPrice) {
                          isCheckedHighToLowPrice = false;
                        } else {
                          isCheckedHighToLowPrice = true;
                          isCheckedLowToHighPrice = false;
                          isCheckedNewFirst = false;
                          isCheckedOldFirst = false;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        isCheckedHighToLowPrice
                            ? Colors.orange
                            : Colors.white, // Change color on click
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: const Color.fromARGB(255, 255, 140, 0)),
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft, // Align text to the left
                      child: Text(
                        "ราคาสูงไปต่ำ",
                        style: TextStyle(color: Colors.black), // Set text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        if (isCheckedLowToHighPrice) {
                          isCheckedLowToHighPrice = false;
                        } else {
                          isCheckedLowToHighPrice = true;
                          isCheckedHighToLowPrice = false;
                          isCheckedNewFirst = false;
                          isCheckedOldFirst = false;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        isCheckedLowToHighPrice
                            ? Colors.orange
                            : Colors.white, // Change color on click
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: const Color.fromARGB(255, 255, 140, 0)),
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft, // Align text to the left
                      child: Text(
                        "ราคาต่ำไปสูง",
                        style: TextStyle(color: Colors.black), // Set text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        if (isCheckedNewFirst) {
                          isCheckedNewFirst = false;
                        } else {
                          isCheckedNewFirst = true;
                          isCheckedHighToLowPrice = false;
                          isCheckedLowToHighPrice = false;
                          isCheckedOldFirst = false;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        isCheckedNewFirst
                            ? Colors.orange
                            : Colors.white, // Change color on click
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: const Color.fromARGB(255, 255, 140, 0)),
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "ใหม่สุดก่อน",
                        style: TextStyle(color: Colors.black), // Set text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        if (isCheckedOldFirst) {
                          isCheckedOldFirst = false;
                        } else {
                          isCheckedOldFirst = true;
                          isCheckedHighToLowPrice = false;
                          isCheckedLowToHighPrice = false;
                          isCheckedNewFirst = false;
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        isCheckedOldFirst
                            ? Colors.orange
                            : Colors.white, // Change color on click
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: const Color.fromARGB(255, 255, 140, 0)),
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "เก่าสุดก่อน",
                        style: TextStyle(color: Colors.black), // Set text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 15,
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, {
                  'minPrice': minPrice,
                  'maxPrice': maxPrice,
                  'isCheckedHighToLowPrice': isCheckedHighToLowPrice,
                  'isCheckedLowToHighPrice': isCheckedLowToHighPrice,
                  'isCheckedNewFirst': isCheckedNewFirst,
                  'isCheckedOldFirst': isCheckedOldFirst,
                  'selectedTags': selectedTags,
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Color.fromARGB(255, 243, 221, 19)),
              ),
              child: Text(
                "Apply",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
