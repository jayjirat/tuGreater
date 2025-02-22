import 'package:flutter/material.dart';
import 'package:frontend/components/item_image_slider.dart';
import 'package:frontend/components/report_modal.dart';
import 'package:frontend/components/toolbar.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({super.key});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: Toolbar(title: "Item Detail"),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 254, 227, 121),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    )),
                child: Stack(
                  children: [
                    Center(
                      child: ItemImageSlider(),
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.only(left: 5, top: 10), //ที่ว่างขอบจอซ้าย
                  child: Row(
                    children: [
                      for (var i = 0; i < 7; i++)
                        Container(
                          //ช่องสี่เหลี่ยม
                          height: 40,
                          width: 65,
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
                            child: Center(
                                child: Text(
                              "Tag",
                              style: TextStyle(fontSize: 16),
                            )),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        "Item Name",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 180),
                      Text(
                        "100 ฿",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "@Wernatraa",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "08/02/2004",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, top: 15, right: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "lorem ipsum dolor sit amet lorem in reprehender nunc non proident null null null null null null null null null null null null null null null null null null null null null null null null null null null",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30, top: 25, right: 30),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return ReportModal();
                          });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    child: Text(
                      "Report",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          )),
        ));
  }
}
