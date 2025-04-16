import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/toast.dart';
import 'package:frontend/models/comment.dart';
import 'package:http/http.dart' as http;

class CommentNotifier extends StateNotifier<List<Comment>> {
  CommentNotifier(this.postId) : super([]);

  final String postId;

  final String baseURL = "http://10.0.2.2:8080";

  Future<void> addComment(
      {required String postId,
      required String content,
      required String userId,
      required String username,
      required String commentedByImageUrl}) async {
    final url = Uri.parse('$baseURL/community/$postId/comment');
    try {
      final commentBody = {
        'content': content,
        'createdAt': DateTime.now().toIso8601String(),
        'postId': postId,
        'userId': userId,
        'username': username,
        'commentedByImageUrl': commentedByImageUrl
      };
      final header = {'Content-Type': 'application/json'};
      final response = await http.post((url),
          headers: header, body: jsonEncode(commentBody));
      if (response.statusCode == 201) {
        final newComment = Comment.fromJson(jsonDecode(response.body));
        state = [...state, newComment];
      } else {
        showToast(
            message: "Fail to add a comment, please try again",
            toastType: ToastType.error);
      }
    } catch (e) {
      throw Exception(
          'Unable to add a comment. Please check your connection and try again.');
    }
  }

  Future<void> fetchCommentByPostId(String postId) async {
    final url = Uri.parse('$baseURL/community/$postId/comment');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final commentsData =
            data.map((json) => Comment.fromJson(json)).toList();
        state = commentsData;
      } else {
        showToast(
            message: "Fail to load comments, please try again",
            toastType: ToastType.error);
      }
    } catch (e) {
      throw Exception(
          'Unable to load comments. Please check your connection and try again.');
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    final url = Uri.parse('$baseURL/community/$postId/comment/$commentId');
    try {
      final response = await http.delete(url);
      if (response.statusCode != 200) {
        showToast(
            message: "Fail to delete a comment, please try again",
            toastType: ToastType.error);
      } else {
        state = state.where((comment) => comment.id != commentId).toList();
      }
    } catch (e) {
      throw Exception(
          'Unable to delete a comment. Please check your connection and try again.');
    }
  }
}

final commentProvider =
    StateNotifierProvider.family<CommentNotifier, List<Comment>, String>(
  (ref, postId) => CommentNotifier(postId),
);
