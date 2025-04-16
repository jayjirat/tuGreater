import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/role.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/services/user_api.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  Role parseStringtoRole(String role) {
    return role == "admin" ? Role.admin : Role.user;
  }

  String parseRoletoString(Role role) {
    return role == Role.admin ? "Admin" : "User";
  }

  final userDBUrl = "http://10.0.2.2:8080/users";

  Future<void> login(
      String username, String password, BuildContext context) async {
    final url = 'https://restapi.tu.ac.th/api/v1/auth/Ad/verify';

    try {
      final tuResponse = await http.post(
        Uri.parse(url),
        body: json.encode({'UserName': username, 'PassWord': password}),
        headers: {
          'Content-Type': 'application/json',
          'Application-Key':
              'TU43dbf40881f67122e5d01de44b07e49b30df28a5025c449497f5caf4fd1b4c3e72a7568e1e011c6ec05690c64ae48982'
        },
      );
      // Login success
      if (tuResponse.statusCode == 200) {
        print("Login success");
        final tuResponseData = json.decode(tuResponse.body);
        final usernameUrl =
            Uri.parse('$userDBUrl/studentId?studentId=$username');

        // Fetch user in db
        final existingUser = await http.get(usernameUrl);
        final usernameNew = tuResponseData['displayname_en'];
        print(existingUser.statusCode);
        // User not found in db -> Create new user (First Login)
        if (existingUser.statusCode == 404) {
          final userBody = json.encode({
            "studentId": username,
            "username": usernameNew,
            "displayName": "",
            "profileImageUrl": "",
            "role": "User"
          });

          print("login3");
          final createUserResponse = await http.post(Uri.parse(userDBUrl),
              headers: {"content-type": "application/json"}, body: userBody);
          if (createUserResponse.statusCode == 201) {
            if (context.mounted) {
              final data = json.decode(createUserResponse.body);
              state = User(
                id: data["user"]['id'],
                studentId: data["user"]['studentId'],
                username: data["user"]['username'],
                displayName: data["user"]['displayName'],
                profileImageUrl: data["user"]['profileImageUrl'],
                role: parseStringtoRole(data["user"]['role']),
              );
              Navigator.pushReplacementNamed(context, '/set-display-name');
            }
          } else {
            // TODO  Notify the error to user
          }

          // Found user in db -> Not first login
        } else if (existingUser.statusCode == 200) {
          final data = json.decode(existingUser.body);
          state = User(
            id: data['id'],
            studentId: data['studentId'],
            username: data['username'],
            displayName: data['displayName'],
            profileImageUrl: data['profileImageUrl'],
            role: parseStringtoRole(data['role']),
          );
          await _saveUserToPrefs(state!);
          // TODO  push -> community screen
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/community');
          }
        } else {
          // TODO  Notify the error to user
        }

        // Login unsuccessful
      } else {
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ลบข้อมูล user ที่เซฟไว้

    state = null; // ล้าง user ออกจาก provider
  }

  Future<User?> getUserById({required String userId}) async {
    final url = Uri.parse('$userDBUrl/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User(
          id: data['id'],
          studentId: data['studentId'],
          username: data['username'],
          displayName: data['displayName'],
          profileImageUrl: data['profileImageUrl'],
          role: parseStringtoRole(data['role']),
        );
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
            'Failed to load user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> updateUser(
      {bool isFirst = false,
      required User user,
      required BuildContext context,
      required String username,
      required String displayName,
      required String profileImageUrl}) async {
    Map<String, dynamic> editUser = {
      "studentId": user.studentId,
      "username": username,
      "displayName": displayName,
      "profileImageUrl": profileImageUrl,
      "role": parseRoletoString(user.role),
    };
    try {
      final response = await http.put(
        Uri.parse("$userDBUrl/${user.id}"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(editUser),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        state = User(
          id: data['id'],
          studentId: data['studentId'],
          username: data['username'],
          displayName: data['displayName'],
          profileImageUrl: data['profileImageUrl'],
          role: parseStringtoRole(data['role']),
        );
        await _saveUserToPrefs(state!);
        if (isFirst) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/community');
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  // บันทึกข้อมูล User ลง SharedPreferences
  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', user.id);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setInt('loginTimeStamp', DateTime.now().microsecondsSinceEpoch);
  }

// โหลดข้อมูล User จาก SharedPreferences
  Future<bool> checkLoginSessionAndLoadUser() async {
    final prefs = await SharedPreferences.getInstance();

    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final loginTimestamp = prefs.getInt('loginTimestamp');

    // ถ้ายังไม่เคย login หรือไม่มี timestamp
    if (!isLoggedIn || loginTimestamp == null) {
      return false;
    }

    final loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
    final now = DateTime.now();

    // ตั้งระยะเวลา session เช่น 2 ชั่วโมง
    const sessionDuration = Duration(hours: 72);

    // หมดอายุแล้ว
    if (now.difference(loginTime) > sessionDuration) {
      await prefs.clear(); // หรือลบแค่ key ที่เกี่ยวข้อง
      return false;
    }

    // ยังไม่หมดอายุ → โหลดข้อมูลผู้ใช้ (อาจจะต้องเรียก API หรือดึงจาก local cache)
    try {
      final id = prefs.getString('id'); // ต้องเซฟเพิ่มตอน login
      if (id == null) return false;

      final userResponse = await http.get(Uri.parse('$userDBUrl/$id'));
      if (userResponse.statusCode == 200) {
        final data = json.decode(userResponse.body);
        state = User(
          id: data['id'],
          studentId: data['studentId'],
          username: data['username'],
          displayName: data['displayName'],
          profileImageUrl: data['profileImageUrl'],
          role: parseStringtoRole(data['role']),
        );
        return true;
      }
    } catch (e) {
      print('Error loading user: $e');
      return false;
    }

    return false;
  }

  Future<void> loadUser(String studentId) async {
    final user = await UserApi.fetchUser(studentId);
    state = user;
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());
