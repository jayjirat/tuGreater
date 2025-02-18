import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/com_post.dart';
import 'package:http/http.dart' as http;

class CommunityNotifier extends StateNotifier<List<CommuPost>> {
  CommunityNotifier() : super([]);

  CommuPost? post;
  bool isLoading = false;

  Future<void> fetchPosts() async {
    final url =
        Uri.parse('https://67b44379392f4aa94faa1224.mockapi.io/commuPosts');

    try {
      // isLoading = true;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final posts = data.map((json) => CommuPost.fromJson(json)).toList();
        state = posts;
        // isLoading = false;
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
      isLoading = true;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        post = CommuPost.fromJson(data);
        isLoading = false;
        state = [...state];
      } else {
        throw Exception(
            'Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> createPost({String? title, String? description}) async {
    final url = 'https://67b44379392f4aa94faa1224.mockapi.io/commuPosts';
    try {
      final Map<String, dynamic> newPost = {
        'title': title,
        'description': description ?? '',
        'likeCount': 0,
        'userId': '999', // Mock
        'likedBy': [],
        'isEdited': false,
        'isPinned': false,
        'comments': [],
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
        'imageUrl': '' // Mock
      };

      final header = {'Content-Type': 'application/json'};

      final response = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(newPost));
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final newPostModel = CommuPost.fromJson(data);
        state = [newPostModel, ...state];
      } else {
        throw Exception(
            'Failed to create post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, List<CommuPost>>(
        (ref) => CommunityNotifier());
