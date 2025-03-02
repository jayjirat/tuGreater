import 'package:flutter/material.dart';

Widget inputWithLabel({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
  required bool obscureText,
  TextInputType? textInputType,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
        obscureText: obscureText,
        keyboardType: textInputType ?? TextInputType.text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16),
          ),
          filled: true,
          fillColor: const Color(0xFFF0F5FA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    ],
  );
}
