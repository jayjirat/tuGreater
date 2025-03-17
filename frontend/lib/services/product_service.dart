import 'dart:convert';
import 'package:frontend/models/Products.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/Products.dart';

class ProductService {
  static const String baseUrl = 'http://10.0.2.2:8080/shop';

  // Fetch all products
  Future<List<Products>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      // Decode the response body with UTF-8
      String decodedResponse = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodedResponse);
      return jsonData.map((json) => Products.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch product by id
  Future<Products> fetchProductDetail(String productId) async {
    final response = await http.get(Uri.parse(baseUrl + "/${productId}"));

    if (response.statusCode == 200) {
      // Decode the response body with UTF-8
      String decodedResponse = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(decodedResponse);
      return Products.fromJson(jsonData);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Products>> searchProducts(String query) async {
    final response =
        await http.get(Uri.parse("$baseUrl/search?productName=$query"));

    if (response.statusCode == 200) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = json.decode(decodedResponse);
      return jsonList.map((json) => Products.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Products>> selectCategory(String category) async {
    final response = await http.get(Uri.parse("$baseUrl/product/$category"));

    if (response.statusCode == 200) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = json.decode(decodedResponse);
      return jsonList.map((json) => Products.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Products>> searchWithCategory(
      String query, int categoryIndex) async {
    List<String> categories = [
      'Food',
      'Drink',
      'Clothes',
      'Dormitory',
      'Others'
    ];
    String category = categories[categoryIndex];

    final response = await http.get(
      Uri.parse(
          "$baseUrl/searchByCategoryAndName?name=$query&category=$category"),
    );

    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      List<dynamic> jsonList = json.decode(decodedResponse);
      return jsonList.map((json) => Products.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products by category');
    }
  }
}
