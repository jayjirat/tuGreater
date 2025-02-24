import 'dart:convert';

class Products {
  final String productId;
  final List<String> productImageUrls;
  final String productName;
  final double productPrice;
  final DateTime productDatePost;
  final List<String> productTags;
  final String productDescription;
  final String productCategory;
  final String productOwner;

  Products({
    required this.productId,
    required this.productImageUrls,
    required this.productName,
    required this.productPrice,
    required this.productDatePost,
    required this.productTags,
    required this.productDescription,
    required this.productCategory,
    required this.productOwner,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      productId: json['id'] ?? '', // Provide a default empty string
      productImageUrls:
          List<String>.from(json['productImageUrls'] ?? []), // Handle null case
      productName: json['productName'] ?? '', // Provide a default empty string
      productPrice:
          (json['productPrice'] ?? 0).toDouble(), // Provide a default value
      productDatePost: DateTime.tryParse(json['productDatePost'] ?? '') ??
          DateTime.now(), // Default to now if null
      productTags:
          List<String>.from(json['productTags'] ?? []), // Handle null case
      productDescription:
          json['productDescription'] ?? '', // Provide a default empty string
      productCategory:
          json['productCategory'] ?? '', // Provide a default empty string
      productOwner:
          json['productOwner'] ?? '', // Provide a default empty string
    );
  }

  // Convert Product object to JSON (to send to backend)
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productImageUrls': productImageUrls,
      'productName': productName,
      'productPrice': productPrice,
      'productDatePost': productDatePost.toIso8601String(),
      'productTags': productTags,
      'productDescription': productDescription,
      'productCategory': productCategory,
      'productOwner': productOwner,
    };
  }
}
