import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/report.dart';
import 'package:http/http.dart' as http;

final reportProvider = StateNotifierProvider<ReportNotifier, List<Report>>(
  (ref) => ReportNotifier(),
);

class ReportNotifier extends StateNotifier<List<Report>> {
  ReportNotifier() : super([]);

  final String baseURL = "http://10.0.2.2:8080";

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
