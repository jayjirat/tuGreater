import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:frontend/models/products.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductService {
  static const String baseUrl = 'https://tugreaterbackend.onrender.com/shop';

  // Fetch all products
  Future<List<Products>> fetchProducts({required BuildContext context}) async {
    try {
      final response =
          await http.get(Uri.parse(baseUrl)).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        // Decode the response body with UTF-8
        String decodedResponse = utf8.decode(response.bodyBytes);
        List<dynamic> jsonData = json.decode(decodedResponse);
        return jsonData.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception(
            "${AppLocalizations.of(context)!.createProductFail} ${AppLocalizations.of(context)!.pleaseTryAgain}");
      }
    } catch (e) {
      throw Exception(
          "${AppLocalizations.of(context)!.unableCreateProduct} ${AppLocalizations.of(context)!.checkYourConnection}");
    }
  }

  // Fetch product by id
  Future<Products> fetchProductDetail(
      {required String productId, required BuildContext context}) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/$productId"))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Decode the response body with UTF-8
        String decodedResponse = utf8.decode(response.bodyBytes);
        final jsonData = json.decode(decodedResponse);
        return Products.fromJson(jsonData);
      } else {
        throw Exception(
            "${AppLocalizations.of(context)!.createProductFail} ${AppLocalizations.of(context)!.pleaseTryAgain}");
      }
    } catch (e) {
      throw Exception(
          "${AppLocalizations.of(context)!.unableCreateProduct} ${AppLocalizations.of(context)!.checkYourConnection}");
    }
  }

  Future<List<Products>> searchProducts(
      {required String query, required BuildContext context}) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/search?productName=$query"))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        List<dynamic> jsonList = json.decode(decodedResponse);
        return jsonList.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception(
            "${AppLocalizations.of(context)!.createProductFail} ${AppLocalizations.of(context)!.pleaseTryAgain}");
      }
    } catch (e) {
      throw Exception(
          "${AppLocalizations.of(context)!.unableCreateProduct} ${AppLocalizations.of(context)!.checkYourConnection}");
    }
  }

  Future<List<Products>> selectCategory(
      {required String category, required BuildContext context}) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/product/$category"))
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        List<dynamic> jsonList = json.decode(decodedResponse);
        return jsonList.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception(
            "${AppLocalizations.of(context)!.createProductFail} ${AppLocalizations.of(context)!.pleaseTryAgain}");
      }
    } catch (e) {
      throw Exception(
          "${AppLocalizations.of(context)!.unableCreateProduct} ${AppLocalizations.of(context)!.checkYourConnection}");
    }
  }

  Future<List<Products>> searchWithCategory(
      {required String query,
      required int categoryIndex,
      required BuildContext context}) async {
    try {
      query = query.trim();

      List<String> categories = [
        'Food',
        'Drink',
        'Clothes',
        'Dormitory',
        'Others'
      ];
      String category = categories[categoryIndex];

      final response = await http
          .get(
            Uri.parse(
                "$baseUrl/searchByCategoryAndName?category=$category&name=$query"),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        String decodedResponse = utf8.decode(response.bodyBytes);
        List<dynamic> jsonList = json.decode(decodedResponse);
        return jsonList.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception(
            "${AppLocalizations.of(context)!.createProductFail} ${AppLocalizations.of(context)!.pleaseTryAgain}");
      }
    } catch (e) {
      throw Exception(
          "${AppLocalizations.of(context)!.unableCreateProduct} ${AppLocalizations.of(context)!.checkYourConnection}");
    }
  }

  Future<List<Products>> fetchAllManageProducts(
      {required String productOwnerId, required BuildContext context}) async {
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/manage/$productOwnerId"))
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        // Decode the response body with UTF-8
        String decodedResponse = utf8.decode(response.bodyBytes);
        List<dynamic> jsonData = json.decode(decodedResponse);
        return jsonData.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception(
            "${AppLocalizations.of(context)!.createProductFail} ${AppLocalizations.of(context)!.pleaseTryAgain}");
      }
    } catch (e) {
      throw Exception(
          "${AppLocalizations.of(context)!.unableCreateProduct} ${AppLocalizations.of(context)!.checkYourConnection}");
    }
  }

  Future<void> deleteProduct(
      {required String productOwnerId,
      required String productId,
      required BuildContext context}) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/$productOwnerId/$productId"))
          .timeout(Duration(seconds: 5));
      if (response.statusCode != 200) {
        throw Exception(
            "${AppLocalizations.of(context)!.createProductFail} ${AppLocalizations.of(context)!.pleaseTryAgain}");
      }
    } catch (e) {
      throw Exception(
          "${AppLocalizations.of(context)!.unableCreateProduct} ${AppLocalizations.of(context)!.checkYourConnection}");
    }
  }

  Future<Products> updateProduct(
      {required String productOwnerId,
      required String productId,
      required Map<String, dynamic> updatedFields,
      required BuildContext context}) async {
    try {
      const String baseUrl = 'https://tugreaterbackend.onrender.com/shop';
      final response = await http
          .put(
            Uri.parse("$baseUrl/$productOwnerId/$productId"),
            headers: {
              "Content-Type": "application/json",
            },
            body: jsonEncode(updatedFields),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Products.fromJson(jsonData);
      } else {
        throw Exception(
            "${AppLocalizations.of(context)!.createProductFail} ${AppLocalizations.of(context)!.pleaseTryAgain}");
      }
    } catch (e) {
      throw Exception(
          "${AppLocalizations.of(context)!.unableCreateProduct} ${AppLocalizations.of(context)!.checkYourConnection}");
    }
  }
}
