import 'package:flutter/material.dart';
import 'package:frontend/models/products.dart';
import 'package:frontend/screens/error_try.dart';
import 'package:frontend/screens/shop/item_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/product_provider.dart';
import 'package:tuple/tuple.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final productsAsyncValue = _getProducts(ref: ref, context: context);

    return Expanded(
      child: productsAsyncValue.when(
        data: (products) {
          List<Products> filteredProducts = _applyFilters(products);
          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(productProvider(context));
            },
            child: products.isNotEmpty
                ? LayoutBuilder(builder: (context, constraints) {
                    return GridView.builder(
                      itemCount: filteredProducts.length,
                      physics: AlwaysScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: (constraints.maxWidth / 2) / 290,
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
                                        builder: (context) => ItemDetail(
                                            productId: product.productId)));
                              },
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).cardColor,
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
                                        child: product
                                                .productImageUrls.isNotEmpty
                                            ? Image.network(
                                                product.productImageUrls[0],
                                                fit: BoxFit.cover,
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .canvasColor
                                                        .withValues(
                                                            alpha: 0.2)),
                                                child: Icon(
                                                    Icons.image_not_supported,
                                                    size: 42,
                                                    color: Theme.of(context)
                                                        .cardColor),
                                              ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.productName,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "฿ ${NumberFormat('#,###').format(product.productPrice)}",
                                            style: TextStyle(
                                              fontSize: 15,
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
                  })
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 120,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          AppLocalizations.of(context)!.noProducts,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.noProductsContent,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorTry(
            errorMessage: error.toString(),
            ref: ref,
            provider: productProvider),
      ),
    );
  }

  AsyncValue<List<Products>> _getProducts(
      {required WidgetRef ref, required BuildContext context}) {
    if (searchQuery.isEmpty && selectedCategory == -1) {
      return ref.watch(productProvider(context));
    }

    if (searchQuery.isNotEmpty && selectedCategory == -1) {
      return ref.watch(productSearchProvider(Tuple2(searchQuery, context)));
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
      return ref
          .watch(productSelectCategoryProvider(Tuple2(category, context)));
    }

    return ref.watch(productSearchWithCategoryProvider(
        Tuple3(searchQuery, selectedCategory, context)));
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
