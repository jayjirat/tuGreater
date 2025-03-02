import 'package:flutter/material.dart';
import 'package:frontend/components/label_input.dart';
import 'package:frontend/components/login_stack.dart';

class ConfirmationPage extends StatelessWidget {
  ConfirmationPage({super.key});
  final displayNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return loginStack(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80,
          ),
          Text(
            'Set your Display name',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          inputWithLabel(
              context: context,
              controller: displayNameController,
              hintText: "",
              obscureText: false),
          SizedBox(height: 32.0),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Confirmed')));
            },
            child: Text('CONFIRM'),
          ),
        ],
      ),
    );
  }
}
