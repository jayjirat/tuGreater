import 'package:flutter/widgets.dart';
import 'package:frontend/models/products.dart';
import 'package:frontend/services/product_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

final productProvider = FutureProvider.family<List<Products>,BuildContext>((ref,context) async {
  return ProductService().fetchProducts(context: context);
});

final productProviderById = FutureProvider.family<Products, Tuple2<String, BuildContext>>(
  (ref, tuple) async {
    final productId = tuple.item1;
    final context = tuple.item2;
    return ProductService().fetchProductDetail(productId: productId, context: context);
  },
);


final productSearchProvider = FutureProvider.family<List<Products>, Tuple2<String, BuildContext>>(
  (ref, tuple) async {
    final query = tuple.item1;
    final context = tuple.item2;
    return ProductService().searchProducts(query: query, context: context);
  },
);


final productSelectCategoryProvider = FutureProvider.family<List<Products>, Tuple2<String, BuildContext>>(
  (ref, tuple) async {
    final category = tuple.item1;
    final context = tuple.item2;
    return ProductService().selectCategory(category: category, context: context);
  },
);


final productSearchWithCategoryProvider = FutureProvider.family<List<Products>, Tuple3<String, int, BuildContext>>(
  (ref, tuple) async {
    final query = tuple.item1;
    final categoryIndex = tuple.item2;
    final context = tuple.item3;
    return ProductService().searchWithCategory(query: query, categoryIndex: categoryIndex, context: context);
  },
);


final productProviderByProductOwnerId = FutureProvider.family<List<Products>, Tuple2<String, BuildContext>>(
  (ref, tuple) async {
    final productOwnerId = tuple.item1;
    final context = tuple.item2;
    return ProductService().fetchAllManageProducts(productOwnerId: productOwnerId, context: context);
  },
);


final deleteProduct = FutureProvider.family<void, Tuple3<String, String, BuildContext>>(
  (ref, tuple) async {
    final productOwnerId = tuple.item1;
    final productId = tuple.item2;
    final context = tuple.item3;
    return ProductService().deleteProduct(productOwnerId: productOwnerId, productId: productId, context: context);
  },
);


final updateProduct = FutureProvider.family<Products, Tuple4<String, String, Map<String, dynamic>, BuildContext>>(
  (ref, tuple) async {
    final productOwnerId = tuple.item1;
    final productId = tuple.item2;
    final updatedFields = tuple.item3;
    final context = tuple.item4;
    return ProductService().updateProduct(productOwnerId: productOwnerId, productId: productId, updatedFields: updatedFields, context: context);
  },
);

