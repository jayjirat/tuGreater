import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/role.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/user.dart';

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
        final tuResponseData = json.decode(tuResponse.body);
        final usernameUrl = Uri.parse('$userDBUrl/$username');

        // Fetch user in db
        final existingUser = await http.get(usernameUrl);
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

          final createUserResponse = await http.post(Uri.parse(userDBUrl),
              headers: {"content-type": "application/json"}, body: userBody);
          if (createUserResponse.statusCode == 201) {
            if (context.mounted) {
              final data = json.decode(createUserResponse.body);
              state = User(
                studentId: data["user"]['studentId'],
                username: data["user"]['username'],
                displayName: data["user"]['displayName'],
                profileImageUrl: data["user"]['profileImageUrl'],
                role: parseStringtoRole(data["user"]['role']),
              );
              Navigator.pushReplacementNamed(context, '/set-display-name');
            }
          } else {
            print("error");
            // TODO  Notify the error to user
          }

          // Found user in db -> Not first login
        } else if (existingUser.statusCode == 200) {
          final data = json.decode(existingUser.body);
          state = User(
            studentId: data['studentId'],
            username: data['username'],
            displayName: data['displayName'],
            profileImageUrl: data['profileImageUrl'],
            role: parseStringtoRole(data['role']),
          );
          // TODO  push -> community screen
          print("Community screen");
        } else {
          print("error");
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

  Future<void> setDisplayName(String displayName, BuildContext context) async {
    final id = state!.studentId;
    Map<String, dynamic> editUser = {
      "studentId": state!.studentId,
      "username": state!.username,
      "displayName": displayName,
      "profileImageUrl": state!.profileImageUrl,
      "role": parseRoletoString(state!.role),
    };
    try {
      final response = await http.put(
        Uri.parse("$userDBUrl/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(editUser),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        state = User(
          studentId: data['studentId'],
          username: data['username'],
          displayName: data['displayName'],
          profileImageUrl: data['profileImageUrl'],
          role: parseStringtoRole(data['role']),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}

final userProvider =
    StateNotifierProvider<UserNotifier, User?>((ref) => UserNotifier());
