import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/report.dart';
import 'package:http/http.dart' as http;

class ReportNotifier extends StateNotifier<List<Report>> {
  ReportNotifier() : super([]);
  String baseURL = "http://10.0.2.2:8080";
  Future<void> createReport(
      {required List<String> reportReasons,
      required String additionalInfo,
      required String reportedBy,
      required String postId,
      required PostCategory postCategory}) async {
    final url = Uri.parse('$baseURL/report');
    try {
      final Map<String, dynamic> newReport = {
        'reportReasons': reportReasons,
        'additionalInfo': additionalInfo,
        'status': ReportStatus.underReview.name,
        'reportedBy': reportedBy,
        'postId': postId,
        'postCategory': postCategory.name,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };
      final header = {'Content-Type': 'application/json'};

      final response = await http
          .post(url, headers: header, body: jsonEncode(newReport))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedResponse);
        final newReport = Report.fromJson(data);
        state = [newReport, ...state];
      } else {
        throw Exception(
            'Failed to create report. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> fetchReports() async {
    final url = Uri.parse('$baseURL/report');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final report = jsonData.map((item) => Report.fromJson(item)).toList();
        state = report;
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deleteReport(String postId) async {
    final url = Uri.parse('$baseURL/report/$postId');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        state = state.where((report) => report.id != postId).toList();
      } else {
        throw Exception('Failed to delete report');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

final reportProvider = StateNotifierProvider<ReportNotifier, List<Report>>(
    (ref) => ReportNotifier());
