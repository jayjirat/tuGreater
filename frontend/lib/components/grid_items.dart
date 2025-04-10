import 'package:flutter/material.dart';
import 'package:frontend/models/Products.dart';
import 'package:frontend/screens/shop/item_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/provider/product_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';

class GridItems extends ConsumerWidget {
  final String searchQuery;
  final int selectedCategory;
  final double? minPrice;
  final double? maxPrice;
  final bool isCheckedHighToLowPrice;
  final bool isCheckedLowToHighPrice;
  final bool isCheckedNewFirst;
  final bool isCheckedOldFirst;
  final List<String> selectedTags;

  const GridItems({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    this.minPrice,
    this.maxPrice,
    required this.isCheckedHighToLowPrice,
    required this.isCheckedLowToHighPrice,
    required this.isCheckedNewFirst,
    required this.isCheckedOldFirst,
    required this.selectedTags,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = _getProducts(ref);

    return Expanded(
      child: productsAsyncValue.when(
        data: (products) {
          List<Products> filteredProducts = _applyFilters(products);
          return GridView.builder(
            itemCount: filteredProducts.length,
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.715,
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return Container(
                margin: EdgeInsets.all(10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ItemDetail(productId: product.productId)));
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromARGB(255, 254, 227, 121),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 175,
                              child: Image.network(
                                product.productImageUrls.isNotEmpty
                                    ? product.productImageUrls[0]
                                    : 'https://via.placeholder.com/175',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black.withOpacity(0.8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "฿ ${NumberFormat('#,###').format(product.productPrice)}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  AsyncValue<List<Products>> _getProducts(WidgetRef ref) {
    if (searchQuery.isEmpty && selectedCategory == -1) {
      return ref.watch(productProvider);
    }

    if (searchQuery.isNotEmpty && selectedCategory == -1) {
      return ref.watch(productSearchProvider(searchQuery));
    }

    if (searchQuery.isEmpty && selectedCategory != -1) {
      List<String> categories = [
        'Food',
        'Drink',
        'Clothes',
        'Dormitory',
        'Others'
      ];
      String category = categories[selectedCategory];
      return ref.watch(productSelectCategoryProvider(category));
    }

    return ref.watch(productSearchWithCategoryProvider(
        Tuple2(searchQuery, selectedCategory)));
  }

  List<Products> _applyFilters(List<Products> products) {
    List<Products> filteredProducts = List.from(products);

    // price range filter
    if (minPrice != null || maxPrice != null) {
      filteredProducts = filteredProducts.where((product) {
        bool passesMinPrice =
            minPrice == null || product.productPrice >= minPrice!;
        bool passesMaxPrice =
            maxPrice == null || product.productPrice <= maxPrice!;
        return passesMinPrice && passesMaxPrice;
      }).toList();
    }

    // tag filters
    if (selectedTags.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        for (String tag in selectedTags) {
          if (!product.productTags.contains(tag)) {
            return false;
          }
        }
        return true;
      }).toList();
    }

    // sorting price and date
    if (isCheckedHighToLowPrice) {
      filteredProducts.sort((a, b) => b.productPrice.compareTo(a.productPrice));
    } else if (isCheckedLowToHighPrice) {
      filteredProducts.sort((a, b) => a.productPrice.compareTo(b.productPrice));
    } else if (isCheckedNewFirst) {
      filteredProducts
          .sort((a, b) => b.productDatePost.compareTo(a.productDatePost));
    } else if (isCheckedOldFirst) {
      filteredProducts
          .sort((a, b) => a.productDatePost.compareTo(b.productDatePost));
    }

    return filteredProducts;
  }
}
