import 'package:flutter/material.dart';
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
      appBar: Toolbar(title: "Item Name"),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.only(left: 5, top: 5), //ที่ว่างขอบจอซ้าย
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
    );
  }
}
