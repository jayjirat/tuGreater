import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/com_post.dart';
import 'package:http/http.dart' as http;

class CommunityNotifier extends StateNotifier<List<CommuPost>> {
  CommunityNotifier() : super([]);

  CommuPost? post;

  Future<void> fetchPosts() async {
    final url =
        Uri.parse('https://67b44379392f4aa94faa1224.mockapi.io/commuPosts');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final posts = data.map((json) => CommuPost.fromJson(json)).toList();
        state = posts;
      } else {
        throw Exception(
            'Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> fetchPost(String id) async {
    final url =
        Uri.parse('https://67b44379392f4aa94faa1224.mockapi.io/commuPosts/$id');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        post = CommuPost.fromJson(data);
      } else {
        throw Exception(
            'Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, List<CommuPost>>(
        (ref) => CommunityNotifier());
