import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> updateProfileImage(String studentId, String imageUrl) async {
  final url = Uri.parse('http://10.0.2.2:8080/users/profile-image/$studentId');

  // Prepare the request body
  final body = jsonEncode({'studentId': studentId, 'imageUrl': imageUrl});

  try {
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      print('Profile image updated successfully');
      // Handle success scenario
    } else {
      print('Failed to update profile image: ${response.statusCode}');
      print('Response body: ${response.body}');
      // Handle error scenario
    }
  } catch (e) {
    print('Error updating profile image: $e');
    // Handle exception
  }
}
