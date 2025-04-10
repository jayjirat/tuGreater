import 'package:flutter/material.dart';

class imagetext_container extends StatelessWidget {
  final String imageUrl;
  final String text;
  final double containerWidth;
  final double containerHeight;
  final double imageWidth;
  final double spacing;

  const imagetext_container({
    super.key,
    required this.imageUrl,
    required this.text,
    this.containerWidth = 300,
    this.containerHeight = 100,
    this.imageWidth = 80,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: imageWidth,
            fit: BoxFit.cover,
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
