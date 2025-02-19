import 'package:frontend/models/Products.dart';
import 'package:frontend/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = FutureProvider<List<Products>>((ref) async {
  return ProductService().fetchProducts();
});
