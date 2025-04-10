import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/label_input.dart';
import 'package:frontend/components/login_stack.dart';
import 'package:frontend/providers/user_provider.dart';

class ConfirmationPage extends ConsumerWidget {
  ConfirmationPage({super.key});
  final displayNameController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
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
            onPressed: () async {
              if (displayNameController.text.isNotEmpty) {
                await ref.read(userProvider.notifier).updateUser(
                    isFirst: true,
                    user: user!,
                    context: context,
                    username: user.username,
                    displayName: displayNameController.text,
                    profileImageUrl: user.profileImageUrl);
              }
            },
            child: Text('CONFIRM'),
          ),
        ],
      ),
    );
  }
}
