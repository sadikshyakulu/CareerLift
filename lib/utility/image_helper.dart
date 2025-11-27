// lib/utils/image_helper.dart
import 'package:flutter/material.dart';

Widget buildNetworkImage(
    String? url, {
      double? height,
      double? width,
      BoxFit fit = BoxFit.cover,
    }) {
  // Empty or null URL → show placeholder
  if (url == null || url.trim().isEmpty) {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[300],
      child: const Icon(Icons.work, color: Colors.grey, size: 40),
    );
  }

  return Image.network(
    url.trim(),
    height: height,
    width: width,
    fit: fit,
    // This is the correct parameter name for Image.network
    errorBuilder: (context, exception, stackTrace) => Container(
      height: height,
      width: width,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
    ),
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Container(
        height: height,
        width: width,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      );
    },
  );
}