import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/exception/timeout_exception.dart';

Future<void> updateProfileImage(String studentId, String imageUrl) async {
  final url = Uri.parse('http://10.0.2.2:8080/users/profile-image/$studentId');

  // Prepare the request body
  final body = jsonEncode({'studentId': studentId, 'imageUrl': imageUrl});

  try {
    final response = await http
        .put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    )
        .timeout(const Duration(seconds: 10), onTimeout: () {
      throw TimeoutException("Connection Timeout");
    });

    if (response.statusCode == 200) {
      // Handle success scenario
    } else {
      throw Exception("reponse not ok");
      // Handle error scenario
    }
  } on TimeoutException catch (e) {
    throw TimeoutException(e.message);
  } catch (e) {
    throw Exception("problems with api");
  }
}
