import 'dart:convert';

class Products {
  final String productId;
  final List<String> productImageUrls;
  final String productName;
  final double productPrice;
  final DateTime productDatePost;
  final DateTime productDateUpdate;
  final List<String> productTags;
  final String productDescription;
  final String productCategory;
  final String productOwner;
  final String productOwnerId;

  Products({
    required this.productId,
    required this.productImageUrls,
    required this.productName,
    required this.productPrice,
    required this.productDatePost,
    required this.productDateUpdate,
    required this.productTags,
    required this.productDescription,
    required this.productCategory,
    required this.productOwner,
    required this.productOwnerId,
  });

  // Convert JSON to Product object
  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productId: json['id'] ?? '',
      productImageUrls: List<String>.from(json['productImageUrls'] ?? []),
      productName: json['productName'] ?? '',
      productPrice: (json['productPrice'] ?? 0).toDouble(),
      productDatePost:
          DateTime.tryParse(json['productDatePost'] ?? '') ?? DateTime.now(),
      productDateUpdate:
          DateTime.tryParse(json['productDateUpdate'] ?? '') ?? DateTime.now(),
      productTags: List<String>.from(json['productTags'] ?? []),
      productDescription: json['productDescription'] ?? '',
      productCategory: json['productCategory'] ?? '',
      productOwner: json['productOwner'] ?? '',
      productOwnerId: json['productOwnerId'] ?? '',
    );
  }

  // Convert Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productImageUrls': productImageUrls,
      'productName': productName,
      'productPrice': productPrice,
      'productDatePost': productDatePost.toIso8601String(),
      'productDateUpdate': productDateUpdate.toIso8601String(),
      'productTags': productTags,
      'productDescription': productDescription,
      'productCategory': productCategory,
      'productOwner': productOwner,
      'productOwnerId': productOwnerId
    };
  }
}
