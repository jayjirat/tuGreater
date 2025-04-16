import 'dart:convert'; 

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/models/user.dart';


final userListProvider = StateNotifierProvider<UserListNotifier, List<User>>(
  (ref) => UserListNotifier(),
);

class UserListNotifier extends StateNotifier<List<User>> {
  UserListNotifier() : super([]);

  final String baseURL = "http://10.0.2.2:8080";

  Future<void> fetchUser() async {
    final url = Uri.parse('$baseURL/users');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final users = jsonData.map((item) => User.fromJson(item)).toList();
        state = users;
      } else {
      throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}