import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/exception/timeout_exception.dart';

class DisplaynameApiService {
  final String baseUrl = 'http://10.0.2.2:8080/users';

  /// Get the display name of a student by their ID
  ///
  /// Returns a Future with the display name as a String
  Future<String> getStudentDisplayName(String userId) async {
    final url = Uri.parse('$baseUrl/student/$userId/displayName');

    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException("Fail to fetch displayname, please try again");
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['displayName'];
      } else {
        throw Exception('Failed to get display name: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      throw TimeoutException(e.message);
    } catch (e) {
      throw Exception('Error getting display name: $e');
    }
  }

  /// Update the display name of a student by their ID
  ///
  /// Returns a Future<bool> indicating success (true) or failure (false)
  Future<bool> updateStudentDisplayName(
      String userId, String newDisplayName) async {
    final url = Uri.parse('$baseUrl/student/$userId/displayName');

    try {
      final response = await http
          .post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'displayName': newDisplayName,
        }),
      )
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw Exception("Fail to update displayname, please try again");
      });

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception('$e');
    }
  }
}
