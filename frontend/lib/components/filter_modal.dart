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
  bool isCheckedOthers = false;
  bool isCheckedHighToLowPrice = false;
  bool isCheckedLowToHighPrice = false;
  bool isCheckedNewFirst = false;
  bool isCheckedRecommend = false;

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
                        });
                      },
                    ),
                    Text("มือสอง"),
                  ],
                ),
                SizedBox(width: 10),
              ],
            ),
            Row(
              children: [
                Text(
                  "เรียงจากราคา",
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
                        isCheckedHighToLowPrice =
                            !isCheckedHighToLowPrice; // Toggle color on click
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
                        isCheckedLowToHighPrice =
                            !isCheckedLowToHighPrice; // Toggle color on click
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
                Text(
                  "ตัวเลือก",
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
                        isCheckedNewFirst =
                            !isCheckedNewFirst; // Toggle color on click
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
                        isCheckedRecommend =
                            !isCheckedRecommend; // Toggle color on click
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        isCheckedRecommend
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
                        "แนะนำ",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
