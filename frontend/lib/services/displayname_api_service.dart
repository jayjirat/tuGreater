import 'dart:convert';
import 'package:http/http.dart' as http;

class StudentApiService {
  final String baseUrl = 'http://10.0.2.2:8080/api';

  /// Get the display name of a student by their ID
  ///
  /// Returns a Future with the display name as a String
  Future<String> getStudentDisplayName(String studentId) async {
    final url = Uri.parse('$baseUrl/student/$studentId/displayName');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        return data['displayName'];
      } else {
        throw Exception('Failed to get display name: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw Exception('Error getting display name: $e');
    }
  }

  /// Update the display name of a student by their ID
  ///
  /// Returns a Future<bool> indicating success (true) or failure (false)
  Future<bool> updateStudentDisplayName(
      String studentId, String newDisplayName) async {
    final url = Uri.parse('$baseUrl/student/$studentId/displayName');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'displayName': newDisplayName,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('Error updating display name: $e');
    }
  }
}
