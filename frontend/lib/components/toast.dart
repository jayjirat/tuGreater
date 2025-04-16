import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error, info }

void showToast({required String message, required ToastType toastType}) {
  // กำหนดสีของแต่ละประเภทของ Toast
  Color bgColor;
  switch (toastType) {
    case ToastType.success:
      bgColor = Color(0xFF66BB6A);
      break;
    case ToastType.error:
      bgColor = Color(0xFFEF5350);
      break;
    case ToastType.info:
      bgColor = Color(0xFF42A5F5);
      break;
  }

  // แสดง Toast
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    textColor: Colors.white,
    fontSize: 16,
  );
}
