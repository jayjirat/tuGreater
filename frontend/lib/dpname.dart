import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TU GREATER'),
        centerTitle: true, // Center the title
        backgroundColor: Color(
          0xFFE95C00,
        ), // เปลี่ยนสีแถบด้านบนเป็นสีส้ม #E95C00
      ),
      backgroundColor: Colors.white, // เปลี่ยนพื้นหลังเป็นสีขาว
      body: Center(
        // Center the form in the middle of the screen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the children vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the children horizontally
            children: <Widget>[
              // Text to show above the displayname input field
              Text(
                'Set display name', // The label above the input
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8.0,
              ), // Space between the label and the input field
              // displayname TextField
              SizedBox(
                width: 300, // กำหนดความกว้างของกล่องกรอกข้อมูล
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Displayname',
                    labelStyle: TextStyle(color: Colors.red),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  // You can add functionality for the CONFIRM button here
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Confirmed')));
                },
                child: Text('CONFIRM'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
