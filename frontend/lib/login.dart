import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // ฟังก์ชันสำหรับการล็อกอินผ่าน API
  Future<void> _login() async {
    // URL ของ API สำหรับทำการล็อกอิน
    String url =
        'https://restapi.tu.ac.th/api/v1/auth/Ad/verify'; // เปลี่ยน URL เป็น API จริงของคุณ

    // ทำการส่ง POST request ไปยัง API
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'username': usernameController.text,
          'password': passwordController.text
        }),
        headers: {
          'Content-Type': 'application/json',
          'Application-Key':
              'TU43dbf40881f67122e5d01de44b07e49b30df28a5025c449497f5caf4fd1b4c3e72a7568e1e011c6ec05690c64ae48982'
        },
      );

      // ตรวจสอบผลลัพธ์จาก API
      if (response.statusCode == 200) {
        // API ตอบกลับสำเร็จ (login ถูกต้อง)
        final responseData = json.decode(response.body);
        // สมมุติว่า API ส่งกลับ token สำหรับการใช้งาน
        String token = responseData['token'];
      } else {
        // ถ้าการล็อกอินไม่สำเร็จ
        if (mounted) {
          {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
                SnackBar(content: Text('Invalid username or password')));
          }
        }
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      }
    }
  }

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
                    ElevatedButton(onPressed: _login, child: Text('SIGN-IN')),
                  ],
                )),
          ),
        ),
      ]),
    );
  }
}
