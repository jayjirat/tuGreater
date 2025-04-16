import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/toast.dart';
import 'package:frontend/models/com_post.dart';
import 'package:frontend/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunityNotifier extends StateNotifier<List<CommuPost>> {
  CommunityNotifier() : super([]);

  String baseURL = "http://10.0.2.2:8080";
  CommuPost? post;
  List<Comment>? comments;
  bool isLoading = false;

  Future<void> fetchPosts({required BuildContext context}) async {
    final url = Uri.parse('$baseURL/community');
    try {
      isLoading = true;
      final response = await http.get(url).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final posts = data.map((json) => CommuPost.fromJson(json)).toList();
        state = posts;
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.loadPostsFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableLoadPosts} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchMyPosts(
      {required String userId, required BuildContext context}) async {
    final url = Uri.parse('$baseURL/community/me/$userId');
    try {
      isLoading = true;
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final posts = data.map((json) => CommuPost.fromJson(json)).toList();
        state = posts;
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.loadPostsFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableLoadPosts} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> fetchPost(
      {required String id, required BuildContext context}) async {
    final url = Uri.parse('$baseURL/community/$id');

    try {
      isLoading = true;
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        post = CommuPost.fromJson(data);
        state = [...state];
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.loadPostsFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableLoadPosts} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> createPost(
      {required String title,
      String? description,
      required String category,
      required String userId,
      required String username,
      String? imageUrl,
      required String postedByImageUrl,
      required BuildContext context}) async {
    final url = '$baseURL/community';
    try {
      isLoading = true;
      final Map<String, dynamic> newPost = {
        'title': title,
        'description': description ?? '',
        'category': category,
        'likeCount': 0,
        'userId': userId,
        'username': username,
        'isEdited': false,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'imageUrl': imageUrl,
        'repostCount': 0,
        'postedByImageUrl': postedByImageUrl
      };

      final header = {'Content-Type': 'application/json'};

      final response = await http
          .post(Uri.parse(url), headers: header, body: jsonEncode(newPost))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final newPostModel = CommuPost.fromJson(data);
        state = [newPostModel, ...state];
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.createPostFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableCreatePost} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> editPost(
      {required CommuPost oriPost,
      required String title,
      required String description,
      required String category,
      required String imageUrl,
      required BuildContext context}) async {
    final url = '$baseURL/community/${oriPost.id}';
    try {
      isLoading = true;
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

      final response = await http
          .put(Uri.parse(url), headers: header, body: jsonEncode(editPost))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newPostModel = CommuPost.fromJson(data);
        state = [newPostModel, ...state];
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.editPostFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableEditPost} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> deletePost(
      {required String id, required BuildContext context}) async {
    final url = Uri.parse("$baseURL/community/$id");
    try {
      isLoading = true;
      final response = await http.delete(url).timeout(Duration(seconds: 5));
      if (response.statusCode != 200) {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.deletePostFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableDeletePost} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> filterPosts(
      {required String category, required BuildContext context}) async {
    final url = Uri.parse('$baseURL/community/filter?category=$category');
    try {
      isLoading = true;
      final response = await http.get(url).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final posts = data.map((json) => CommuPost.fromJson(json)).toList();
        state = posts;
      } else if (response.statusCode == 404) {
        state = [];
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.filterPostsFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableFilterPosts} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> searchPosts(
      {required String query, required BuildContext context}) async {
    final url = Uri.parse('$baseURL/community/search?query=$query');
    try {
      isLoading = true;
      final response = await http.get(url).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final posts = data.map((json) => CommuPost.fromJson(json)).toList();
        state = posts;
      } else if (response.statusCode == 404) {
        state = [];
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.searchPostsFail} $query, ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableSearchPosts} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } finally {
      isLoading = false;
    }
  }

  Future<void> likePost(
      {required String userId,
      required String postId,
      required BuildContext context}) async {
    final url = Uri.parse('$baseURL/community/like');
    try {
      final likeBody = {'userId': userId, 'postId': postId};
      final header = {'Content-Type': 'application/json'};
      final response = await http
          .post((url), headers: header, body: jsonEncode(likeBody))
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        state = [...state];
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.likePostFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableLikePost} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    }
  }

  Future<void> unlikePost(
      {required String userId,
      required String postId,
      required BuildContext context}) async {
    final url = Uri.parse('$baseURL/community/like');
    try {
      final likeBody = {'userId': userId, 'postId': postId};
      final header = {'Content-Type': 'application/json'};
      final response = await http
          .delete((url), headers: header, body: jsonEncode(likeBody))
          .timeout(Duration(seconds: 5));
      if (response.statusCode == 200) {
        state = [...state];
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.unlikePostFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableUnlikePost} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    }
  }

  Future<bool> isLiked(
      {required String userId,
      required String postId,
      required BuildContext context}) async {
    final url =
        Uri.parse('$baseURL/community/like?userId=$userId&postId=$postId');
    try {
      isLoading = true;
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        return response.body.contains('true');
      } else {
        if (context.mounted) {
          showToast(
              message:
                  "${AppLocalizations.of(context)!.checkLikeStatusFail} ${AppLocalizations.of(context)!.pleaseTryAgain}",
              toastType: ToastType.error);
        } else {
          return false;
        }
      }
    } catch (e) {
      if (context.mounted) {
        throw Exception(
            "${AppLocalizations.of(context)!.unableCheckLikeStatusPost} ${AppLocalizations.of(context)!.checkYourConnection}");
      }
    } finally {
      isLoading = false;
    }
    return false;
  }
}

final communityProvider =
    StateNotifierProvider<CommunityNotifier, List<CommuPost>>(
        (ref) => CommunityNotifier());
