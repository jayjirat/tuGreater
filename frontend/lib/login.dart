import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/label_input.dart';
import 'package:frontend/components/login_stack.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      if (mounted) {
        final isValid = await ref
            .read(userProvider.notifier)
            .checkLoginSessionAndLoadUser(context: context);
        if (isValid) {
          Navigator.pushReplacementNamed(context, '/community');
        }
      }
    });
  }

  // ฟังก์ชันสำหรับการล็อกอินผ่าน API

  @override
  Widget build(BuildContext context) {
    return loginStack(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  AppLocalizations.of(context)!.loginScreenMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                inputWithLabel(
                  context: context,
                  controller: usernameController,
                  hintText: AppLocalizations.of(context)!.studentId,
                  obscureText: false,
                ),
                SizedBox(height: 20),
                inputWithLabel(
                  context: context,
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.password,
                  obscureText: true,
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState?.validate() == true) {
                      final result =
                          await ref.read(userProvider.notifier).login(
                                usernameController.text,
                                passwordController.text,
                                context,
                              );
                      if (!result) {
                        passwordController.clear();
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.signIn),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 200,
          ),
          Text(
            "TU GREATER 0.0.1 (2025030201)",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
