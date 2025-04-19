import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/user.dart'; // your User model

class UserApi {
  static Future<User> fetchUser(String userId) async {
    final url =
        Uri.parse('https://tugreaterbackend.onrender.com/users/$userId');
    final response = await http.get(url).timeout(Duration(seconds: 10));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
