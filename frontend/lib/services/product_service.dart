import 'dart:convert';
import 'package:frontend/models/Products.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/Products.dart';

class ProductService {
  static const String baseUrl = 'http://10.0.2.2:8080/shop';

  // Fetch all products
  Future<List<Products>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl + "/all"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Products.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
