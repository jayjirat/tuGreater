import 'package:flutter/material.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:frontend/pages/edit_items.dart';

class ManageItems extends StatelessWidget {
  var pNames = [
    'Product 1',
    'Product 2',
    'Product 3',
    'Product 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: "Manage Products"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Column(
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        height: 120,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 240, 239, 239),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width / 4,
                              margin: EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFD4ECF7),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                "assets/images/shoe.jpg",
                                height: 70,
                                width: 70,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, top: 20, bottom: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pNames[i],
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    FilledButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditItems()));
                                      },
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.8),
                                        foregroundColor: Colors.black,
                                        elevation: 0,
                                      ),
                                      child: Text("Edit"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 8, right: 8),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.delete),
                                color: Colors.redAccent,
                                tooltip: 'Delete',
                              ),
                            ),
                          ],
                        ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
