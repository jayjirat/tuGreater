import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/user.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  Future<void> login(
      String username, String password, BuildContext context) async {
    // URL ของ API สำหรับทำการล็อกอิน
    String url =
        'https://restapi.tu.ac.th/api/v1/auth/Ad/verify'; // เปลี่ยน URL เป็น API จริงของคุณ

    // ทำการส่ง POST request ไปยัง API
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({'UserName': username, 'PassWord': password}),
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
        print(responseData['username']);
      } else {
        // ถ้าการล็อกอินไม่สำเร็จ
        if (context.mounted) {
          {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
                SnackBar(content: Text('Invalid username or password')));
          }
        }
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      }
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());
