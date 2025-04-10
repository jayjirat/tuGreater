import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/components/toolbar.dart';
import 'package:frontend/screens/shop/edit_items.dart';
import 'package:frontend/provider/product_provider.dart';
import 'package:tuple/tuple.dart';

class ManageItems extends ConsumerWidget {
  final String productOwnerId = "888"; //mockup
  const ManageItems({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productManageAsyncValue =
        ref.watch(productProviderByProductOwnerId(productOwnerId));

    return Scaffold(
      appBar: Toolbar(title: "Manage Products"),
      body: productManageAsyncValue.when(
        data: (products) => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
                ...products.map((product) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 240, 239, 239),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width / 4,
                          margin: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: Color(0xFFD4ECF7),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: product.productImageUrls.isNotEmpty
                              ? Image.network(product.productImageUrls[0],
                                  fit: BoxFit.cover)
                              : Icon(Icons.image_not_supported),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 20, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.productName,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditItems(
                                                productId: product.productId,
                                                productOwnerId:
                                                    productOwnerId)));
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.8),
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                  ),
                                  child: Text("Edit"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 8, right: 8),
                          child: IconButton(
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Confirm Deletion"),
                                  content: Text(
                                      "Are you sure you want to delete this product?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await ref.read(deleteProduct(Tuple2(
                                    product.productOwnerId,
                                    product.productId)));

                                await Future.delayed(
                                    Duration(milliseconds: 100));
                                ref.refresh(productProviderByProductOwnerId(
                                    productOwnerId));

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Product deleted successfully')));
                              }
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.redAccent,
                            tooltip: 'Delete',
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
    );
  }
}
