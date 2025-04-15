import 'package:frontend/models/products.dart';
import 'package:frontend/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

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
    FutureProvider.family<List<Products>, Tuple2<String, int>>(
        (ref, params) async {
  return ProductService().searchWithCategory(params.item1, params.item2);
});

final productProviderByProductOwnerId =
    FutureProvider.family<List<Products>, String>((ref, productOwnerId) async {
  return ProductService().fetchAllManageProducts(productOwnerId);
});

final deleteProduct =
    FutureProvider.family<void, Tuple2<String, String>>((ref, params) async {
  return ProductService().deleteProduct(params.item1, params.item2);
});

final updateProduct = FutureProvider.family<Products,
    Tuple3<String, String, Map<String, dynamic>>>((ref, params) async {
  return ProductService()
      .updateProduct(params.item1, params.item2, params.item3);
});
