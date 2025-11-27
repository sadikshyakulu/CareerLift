// widgets/profile_image_widget.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProfileImageWidget extends StatelessWidget {
  final String? base64String;
  final String? imageUrl;
  final double radius;
  final Color? placeholderColor;

  const ProfileImageWidget({
    Key? key,
    this.base64String,
    this.imageUrl,
    this.radius = 40,
    this.placeholderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // CASE 1: We have Base64 image
    if (base64String != null && base64String!.isNotEmpty && base64String!.trim() != 'null') {
      try {
        String cleaned = base64String!;
        if (cleaned.contains(',')) {
          cleaned = cleaned.split(',').last;
        }
        cleaned = cleaned.trim();
        if (cleaned.length > 100) { // rough check
          final bytes = base64Decode(cleaned);
          return CircleAvatar(
            radius: radius,
            backgroundImage: MemoryImage(bytes),
            backgroundColor: Colors.transparent,
          );
        }
      } catch (e) {
        print("Base64 decode error: $e");
      }
    }

    // CASE 2: We have URL
    if (imageUrl != null && imageUrl!.isNotEmpty && imageUrl!.startsWith('http')) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, __) => null,
      );
    }

    // CASE 3: Fallback - beautiful placeholder
    return CircleAvatar(
      radius: radius,
      backgroundColor: placeholderColor ?? const Color(0xFF9D4EDD),
      child: Icon(
        Icons.person,
        size: radius * 1.2,
        color: Colors.white,
      ),
    );
  }
}