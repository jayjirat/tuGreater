import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // สำหรับการแปลงข้อมูล JSON
import 'package:TUGREATER/lib/dpname.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // ฟังก์ชันสำหรับการล็อกอินผ่าน API
  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // URL ของ API สำหรับทำการล็อกอิน
    String url =
        'https://restapi.tu.ac.th/api/v1/auth/Ad/verify'; // เปลี่ยน URL เป็น API จริงของคุณ

    // ทำการส่ง POST request ไปยัง API
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      // ตรวจสอบผลลัพธ์จาก API
      if (response.statusCode == 200) {
        // API ตอบกลับสำเร็จ (login ถูกต้อง)
        final responseData = json.decode(response.body);
        // สมมุติว่า API ส่งกลับ token สำหรับการใช้งาน
        String token = responseData['token'];

        // คุณสามารถเก็บ token นี้ใน LocalStorage หรือทำการนำไปใช้ในหน้าอื่นๆ
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConfirmationPage(),
          ), // ไปยังหน้าของ dpname.dart
        );
      } else {
        // ถ้าการล็อกอินไม่สำเร็จ
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid username or password')));
      }
    } catch (error) {
      // หากเกิดข้อผิดพลาดในการเชื่อมต่อกับ API
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.red),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: 300,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.red),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(onPressed: _login, child: Text('SIGN-IN')),
            ],
          ),
        ),
      ),
    );
  }
}
