import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final String cacheKey;
  final double height;
  final double width;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.height = 200,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    required this.cacheKey,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        cacheKey: cacheKey,
        height: height,
        width: width,
        fit: fit,
        errorWidget: (context, url, error) {
          print("Error loading image: $error");
          return Container(
            height: height,
            width: width,
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
          );
        },
        fadeInDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
