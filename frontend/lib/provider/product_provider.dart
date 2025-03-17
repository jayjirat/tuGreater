import 'package:frontend/models/Products.dart';
import 'package:frontend/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = FutureProvider<List<Products>>((ref) async {
  return ProductService().fetchProducts();
});

final productProviderById =
    FutureProvider.family<Products, String>((ref, productId) async {
  return ProductService().fetchProductDetail(productId);
});

final productSearchProvider =
    FutureProvider.family<List<Products>, String>((ref, query) async {
  return ProductService().searchProducts(query);
});

final productSelectCategoryProvider =
    FutureProvider.family<List<Products>, String>((ref, category) async {
  return ProductService().selectCategory(category);
});

final productSearchWithCategoryProvider =
    FutureProvider.family<List<Products>, Map<String, dynamic>>(
        (ref, params) async {
  return ProductService().searchWithCategory(
      params['searchQuery'] as String, params['categoryIndex'] as int);
});
