import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/user_provider.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // ฟังก์ชันสำหรับการล็อกอินผ่าน API

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TU GREATER'),
        centerTitle: true,
        backgroundColor: Color(0xFFE95C00),
      ),
      backgroundColor: Colors.white,
      body: ListView(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(color: Colors.red),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.red),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          }),
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() == true) {
                            ref.read(userProvider.notifier).login(
                                usernameController.text,
                                passwordController.text,
                                context);
                          }
                        },
                        child: Text('SIGN-IN')),
                  ],
                )),
          ),
        ),
      ]),
    );
  }
}
