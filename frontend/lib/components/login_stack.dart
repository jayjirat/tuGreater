import 'package:flutter/material.dart';

Widget loginStack({required Widget child}) {
  return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("TU GREATER",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
            const SizedBox(
              height: 5,
            ),
            Text("TU Greater makes TU better", style: TextStyle(fontSize: 16)),
          ],
        ),
        toolbarHeight: 150,
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Color(0xFFE95C00),
      ),
      backgroundColor: Colors.white,
      body: Stack(children: [
        Positioned.fill(
          child: Container(
            color: Color(0xFFE95C00),
          ),
        ),
        SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: child)))
      ]));
}
