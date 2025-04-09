import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/com_post.dart';
import 'package:frontend/models/comment.dart';
import 'package:http/http.dart' as http;

class CommunityNotifier extends StateNotifier<List<CommuPost>> {
  CommunityNotifier() : super([]);

  String baseURL = "http://10.0.2.2:8080";
  CommuPost? post;
  List<Comment>? comments;
  bool isLoading = false;

  Future<void> fetchPosts() async {
    final url = Uri.parse('$baseURL/community');
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

  Future<void> fetchMyPosts(String userId) async {
    final url = Uri.parse('$baseURL/community/me/$userId');
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

  Future<void> fetchPost({required String id}) async {
    final url = Uri.parse('$baseURL/community/$id');

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

  Future<void> createPost(
      {required String title,
      String? description,
      required String category,
      String? imageUrl}) async {
    final url = '$baseURL/community';
    try {
      final Map<String, dynamic> newPost = {
        'title': title,
        'description': description ?? '',
        'category': category,
        'likeCount': 0,
        'userId': '999', // Mock
        'username': 'jay', // Mock
        'isEdited': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'imageUrl': imageUrl // Mock
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

  Future<void> editPost(
      {required CommuPost oriPost,
      required String title,
      required String description,
      required String category,
      required String imageUrl}) async {
    final url = '$baseURL/community/${oriPost.id}';
    try {
      final Map<String, dynamic> editPost = {
        'title': title,
        'description': description,
        'category': category,
        'likeCount': oriPost.likeCount,
        'userId': oriPost.userId,
        'username': oriPost.username,
        'isEdited': true,
        'createdAt': oriPost.createdAt.toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'imageUrl': imageUrl
      };

      final header = {'Content-Type': 'application/json'};

      final response = await http.put(Uri.parse(url),
          headers: header, body: jsonEncode(editPost));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newPostModel = CommuPost.fromJson(data);
        state = [newPostModel, ...state];
      } else {
        throw Exception(
            'Failed to edit post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> deletePost({required String id}) async {
    final url = Uri.parse("$baseURL/community/$id");
    try {
      final response = await http.delete(url);
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete post id: $id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> filterPosts(String category) async {
    final url = Uri.parse('$baseURL/community/filter?category=$category');
    try {
      // isLoading = true;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final posts = data.map((json) => CommuPost.fromJson(json)).toList();
        state = posts;
        // isLoading = false;
      } else if (response.statusCode == 404) {
        state = [];
      } else {
        throw Exception(
            'Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> searchPosts(String query) async {
    final url = Uri.parse('$baseURL/community/search?query=$query');
    try {
      // isLoading = true;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final posts = data.map((json) => CommuPost.fromJson(json)).toList();
        state = posts;
        // isLoading = false;
      } else if (response.statusCode == 404) {
        state = [];
      } else {
        throw Exception(
            'Failed to load posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> likePost(String userId, String postId) async {
    final url = Uri.parse('$baseURL/community/like');
    try {
      final likeBody = {'userId': userId, 'postId': postId};
      final header = {'Content-Type': 'application/json'};
      final response =
          await http.post((url), headers: header, body: jsonEncode(likeBody));
      if (response.statusCode == 200) {
        state = [...state];
      } else {
        throw Exception(
            'Failed to like posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> unlikePost(String userId, String postId) async {
    final url = Uri.parse('$baseURL/community/like');
    try {
      final likeBody = {'userId': userId, 'postId': postId};
      final header = {'Content-Type': 'application/json'};
      final response =
          await http.delete((url), headers: header, body: jsonEncode(likeBody));
      if (response.statusCode == 200) {
        state = [...state];
      } else {
        throw Exception(
            'Failed to unlike posts. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> isLiked(String userId, String postId) async {
    final url =
        Uri.parse('$baseURL/community/like?userId=$userId&postId=$postId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body.contains('true');
      } else {
        throw Exception(
            'Failed to check like status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, List<CommuPost>>(
        (ref) => CommunityNotifier());
