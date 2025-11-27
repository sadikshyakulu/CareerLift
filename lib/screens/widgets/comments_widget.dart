// widgets/comment_widget.dart
import 'package:flutter/material.dart';
import 'profile_image_widget.dart'; // ← SAME WIDGET YOU USE EVERYWHERE

class CommentWidget extends StatefulWidget {
  final String commentId;
  final String commenterId;
  final String commenterName;
  final String commentBody;
  final String commenterImageUrl; // ← This is Base64 string or URL

  const CommentWidget({
    Key? key,
    required this.commentId,
    required this.commenterId,
    required this.commenterName,
    required this.commentBody,
    required this.commenterImageUrl,
  }) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final List<Color> _borderColors = [
    Colors.purpleAccent,
    Colors.deepPurple,
    const Color(0xFFD946EF),
    const Color(0xFF9D4EDD),
    Colors.cyanAccent,
    Colors.pinkAccent,
  ];

  @override
  Widget build(BuildContext context) {
    _borderColors.shuffle();

    // Check if image is Base64 (starts with data:image or just long string)
    final bool isBase64 = widget.commenterImageUrl.isNotEmpty &&
        (widget.commenterImageUrl.startsWith('data:image/') ||
            widget.commenterImageUrl.startsWith('/9j/') ||
            widget.commenterImageUrl.startsWith('iVBOR') ||
            widget.commenterImageUrl.length > 500);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FIXED: Use ProfileImageWidget for perfect Base64 + URL support
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _borderColors[0],
                width: 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _borderColors[0].withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: ProfileImageWidget(
                base64String: isBase64 ? widget.commenterImageUrl : null,
                imageUrl: isBase64 ? null : widget.commenterImageUrl,
                radius: 24,
                placeholderColor: _borderColors[0],
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name with glow
                Text(
                  widget.commenterName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: const Color(0xFF9D4EDD).withOpacity(0.6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // Comment body
                Text(
                  widget.commentBody,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}