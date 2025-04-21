import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/components/toast.dart';
import 'package:frontend/models/role.dart';
import 'package:frontend/screens/error_page.dart';
import 'package:frontend/services/displayname_api_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/services/user_api.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  Role parseStringtoRole(String role) {
    return role == "admin" ? Role.admin : Role.user;
  }

  String parseRoletoString(Role role) {
    return role == Role.admin ? "Admin" : "User";
  }

  final userDBUrl = "http://10.0.2.2:8080/users";

  Future<bool> login(
      String username, String password, BuildContext context) async {
    final url = dotenv.env['TU_API_PATH'] ?? '';

    try {
      final tuResponse = await http.post(
        Uri.parse(url),
        body: json.encode({'UserName': username, 'PassWord': password}),
        headers: {
          'Content-Type': 'application/json',
          'Application-Key': dotenv.env['TU_APPLICATION_KEY'] ?? ''
        },
      ).timeout(Duration(seconds: 15));
      // Login success
      if (tuResponse.statusCode == 200) {
        String decodedResponse = utf8.decode(tuResponse.bodyBytes);
        final tuResponseData = json.decode(decodedResponse);
        final usernameUrl =
            Uri.parse('$userDBUrl/studentId?studentId=$username');
        // Fetch user in db
        final existingUser =
            await http.get(usernameUrl).timeout(Duration(seconds: 10));
        final usernameNew = tuResponseData['displayname_en'];
        // User not found in db -> Create new user (First Login)
        if (existingUser.statusCode == 404) {
          final userBody = json.encode({
            "studentId": username,
            "username": usernameNew,
            "displayName": "",
            "profileImageUrl": "",
            "role": "User"
          });

          final createUserResponse = await http
              .post(Uri.parse(userDBUrl),
                  headers: {"content-type": "application/json"}, body: userBody)
              .timeout(Duration(seconds: 10));
          if (context.mounted) {
            if (createUserResponse.statusCode == 201) {
              String decodedResponse =
                  utf8.decode(createUserResponse.bodyBytes);
              final data = json.decode(decodedResponse);
              state = User(
                id: data["user"]['id'],
                studentId: data["user"]['studentId'],
                username: data["user"]['username'],
                displayName: data["user"]['displayName'],
                profileImageUrl: data["user"]['profileImageUrl'],
                role: parseStringtoRole(data["user"]['role']),
              );
              Navigator.pushReplacementNamed(context, '/set-display-name');
              return true;
            } else {
              showToast(
                  message:
                      "${AppLocalizations.of(context)!.createUserFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
                  toastType: ToastType.error);
              return false;
            }
          }

          // Found user in db -> Not first login
        } else if (existingUser.statusCode == 200) {
          String decodedResponse = utf8.decode(existingUser.bodyBytes);
          final data = json.decode(decodedResponse);
          state = User(
            id: data['id'],
            studentId: data['studentId'],
            username: data['username'],
            displayName: data['displayName'],
            profileImageUrl: data['profileImageUrl'],
            role: parseStringtoRole(data['role']),
          );
          await _saveUserToPrefs(state!);
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, '/community');
            return true;
          }
        } else {
          if (context.mounted) {
            showToast(
                message:
                    "${AppLocalizations.of(context)!.loadUserFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
                toastType: ToastType.error);
          }

          return false;
        }

        // Login unsuccessful
      } else if (tuResponse.statusCode == 400) {
        if (context.mounted) {
          {
            showToast(
              message: AppLocalizations.of(context)!.loginInvalidMessage,
              toastType: ToastType.error,
            );
          }
        }
        return false;
      } else {
        throw Exception(
            "${AppLocalizations.of(context)!.unableLogin} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } catch (error) {
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(
                errorMessage:
                    "${AppLocalizations.of(context)!.unableLogin} ${AppLocalizations.of(context)!.checkYourConnection}",
                fromLogin: true,
              ),
            ));
        return false;
      }
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ลบข้อมูล user ที่เซฟไว้

    state = null; // ล้าง user ออกจาก provider
  }

  Future<User?> getUserById(
      {required String userId, required BuildContext context}) async {
    final url = Uri.parse('$userDBUrl/$userId');
    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);
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
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.loadUserFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(
                  errorMessage:
                      "${AppLocalizations.of(context)!.unableLoadUser} ${AppLocalizations.of(context)!.checkYourConnection}",
                  fromLogin: true),
            ));
      }
    }
    return null;
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
      final response = await http
          .put(
            Uri.parse("$userDBUrl/${user.id}"),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(editUser),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedResponse);
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
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.editUserFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(
                  errorMessage:
                      "${AppLocalizations.of(context)!.unableEditUser} ${AppLocalizations.of(context)!.checkYourConnection}",
                  fromLogin: true),
            ));
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
  Future<bool> checkLoginSessionAndLoadUser(
      {required BuildContext context}) async {
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

      final userResponse = await http
          .get(Uri.parse('$userDBUrl/$id'))
          .timeout(Duration(seconds: 10));
      if (userResponse.statusCode == 200) {
        String decodedResponse = utf8.decode(userResponse.bodyBytes);
        final data = json.decode(decodedResponse);
        state = User(
          id: data['id'],
          studentId: data['studentId'],
          username: data['username'],
          displayName: data['displayName'],
          profileImageUrl: data['profileImageUrl'],
          role: parseStringtoRole(data['role']),
        );
        return true;
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.prefLoadUserFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showToast(
            message:
                "${AppLocalizations.of(context)!.prefLoadUserFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
            toastType: ToastType.error);
      }
      return false;
    }

    return false;
  }

  Future<void> loadUser(String userId) async {
    final user = await UserApi.fetchUser(userId);
    state = user;
  }

  Future<bool> updateDisplayName({
    required String userId,
    required String newDisplayName,
    required BuildContext context,
  }) async {
    final success = await DisplaynameApiService.updateStudentDisplayName(
        userId, newDisplayName);
    if (success) {
      final updatedUser = await getUserById(userId: userId, context: context);
      if (updatedUser != null) {
        state = updatedUser;
      }
      return true;
    }

    return false;
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());
