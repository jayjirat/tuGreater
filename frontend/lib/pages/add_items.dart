import 'package:flutter/material.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class AddItems extends StatefulWidget {
  const AddItems({super.key});

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  bool isCheckedFirstHanded = false;
  bool isCheckedSecondHanded = false;
  bool isCheckedOthers = false;
  TextEditingController customTextController = TextEditingController();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Toolbar(title: "Add Product"),
        body: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(16),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/svg/upload.svg"),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Upload Images", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Price",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 150,
                      child: TextField(
                        keyboardType:
                            TextInputType.number, // Set keyboard to number
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ], // Allow only numbers
                        decoration: InputDecoration(
                          hintText: "Enter Price...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Baht",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Category",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200], // Background color
                ),
                value: selectedCategory,
                hint: Text("Select Category"),
                items:
                    ["Food", "Drink", "Dormitory", "Clothes"].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tag",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
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
                  SizedBox(width: 10), // Spacing

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
                  SizedBox(width: 10), // Spacing

                  // Third checkbox with a text field
                  Row(
                    children: [
                      Checkbox(
                        value: isCheckedOthers,
                        onChanged: (value) {
                          setState(() {
                            isCheckedOthers = value!;
                          });
                        },
                      ),
                      SizedBox(
                        width: 100, // Adjust width as needed
                        child: TextField(
                          controller: customTextController,
                          enabled:
                              isCheckedOthers, // Enable only if checkbox is checked
                          decoration: InputDecoration(
                            hintText: "อื่นๆ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: TextField(
                    maxLines: null,
                    minLines: 5,
                    decoration: InputDecoration(
                      hintText: "Enter Description...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "*โปรดตรวจสอบว่าได้ใส่ช่องทางการติดต่อลงไปในรายละเอียด",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
            ),
            Column(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Push button to the bottom
              children: [
                Padding(
                  padding: EdgeInsets.all(20), // Add spacing at the bottom
                  child: SizedBox(
                    child: FilledButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.orange), // Set orange background
                      ),
                      child: Text(
                        "โพสต์เลย",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18), // White text for contrast
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
