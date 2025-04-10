import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterModal extends StatefulWidget {
  final double? minPrice;
  final double? maxPrice;
  final bool isCheckedFirstHanded;
  final bool isCheckedSecondHanded;
  final bool isCheckedGood;
  final bool isCheckedDelicious;
  final bool isCheckedClean;
  final bool isCheckedHighToLowPrice;
  final bool isCheckedLowToHighPrice;
  final bool isCheckedNewFirst;
  final bool isCheckedOldFirst;
  final List<String> selectedTags;

  const FilterModal({
    super.key,
    this.minPrice,
    this.maxPrice,
    this.isCheckedFirstHanded = false,
    this.isCheckedSecondHanded = false,
    this.isCheckedGood = false,
    this.isCheckedDelicious = false,
    this.isCheckedClean = false,
    this.isCheckedHighToLowPrice = false,
    this.isCheckedLowToHighPrice = false,
    this.isCheckedNewFirst = false,
    this.isCheckedOldFirst = false,
    this.selectedTags = const [],
  });

  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  late bool isCheckedFirstHanded;
  late bool isCheckedSecondHanded;
  late bool isCheckedGood;
  late bool isCheckedDelicious;
  late bool isCheckedClean;
  late bool isCheckedHighToLowPrice;
  late bool isCheckedLowToHighPrice;
  late bool isCheckedNewFirst;
  late bool isCheckedOldFirst;
  late double? minPrice;
  late double? maxPrice;
  late TextEditingController minPriceController;
  late TextEditingController maxPriceController;
  late List<String> selectedTags;

  @override
  void initState() {
    super.initState();
    isCheckedFirstHanded = widget.isCheckedFirstHanded;
    isCheckedSecondHanded = widget.isCheckedSecondHanded;
    isCheckedGood = widget.isCheckedGood;
    isCheckedDelicious = widget.isCheckedDelicious;
    isCheckedClean = widget.isCheckedClean;
    isCheckedHighToLowPrice = widget.isCheckedHighToLowPrice;
    isCheckedLowToHighPrice = widget.isCheckedLowToHighPrice;
    isCheckedNewFirst = widget.isCheckedNewFirst;
    isCheckedOldFirst = widget.isCheckedOldFirst;
    minPrice = widget.minPrice;
    maxPrice = widget.maxPrice;
    minPriceController = TextEditingController(
      text: minPrice?.toInt().toString() ?? '',
    );
    maxPriceController = TextEditingController(
      text: maxPrice?.toInt().toString() ?? '',
    );
    selectedTags = List<String>.from(widget.selectedTags);
  }

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      padding: EdgeInsets.all(24),
      child: Align(
        alignment: Alignment.center,
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
                    controller: minPriceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      minPrice = value.isEmpty ? null : double.tryParse(value);
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
                    controller: maxPriceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                      maxPrice = value.isEmpty ? null : double.tryParse(value);
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
                        isCheckedHighToLowPrice ? Colors.orange : Colors.white,
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
                        "ราคาสูงไปต่ำ",
                        style: TextStyle(color: Colors.black),
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
                        isCheckedLowToHighPrice ? Colors.orange : Colors.white,
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
                        "ราคาต่ำไปสูง",
                        style: TextStyle(color: Colors.black),
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
                        isCheckedNewFirst ? Colors.orange : Colors.white,
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
                        style: TextStyle(color: Colors.black),
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
                        isCheckedOldFirst ? Colors.orange : Colors.white,
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
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 100,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {
                        minPrice = null;
                        maxPrice = null;
                        minPriceController.clear();
                        maxPriceController.clear();
                        isCheckedFirstHanded = false;
                        isCheckedSecondHanded = false;
                        isCheckedGood = false;
                        isCheckedDelicious = false;
                        isCheckedClean = false;
                        isCheckedHighToLowPrice = false;
                        isCheckedLowToHighPrice = false;
                        isCheckedNewFirst = false;
                        isCheckedOldFirst = false;
                        selectedTags.clear();
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 236, 104, 95)),
                    ),
                    child: Text(
                      "Clear",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: FilledButton(
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
