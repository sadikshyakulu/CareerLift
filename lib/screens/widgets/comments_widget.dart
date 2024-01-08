import 'package:flutter/material.dart';

// Widget for displaying comments in a list
class CommentWidget extends StatefulWidget {
  // Unique identifier for the comment
  final String commentId;

  // ID of the commenter
  final String commenterId;

  // Name of the commenter
  final String commenterName;

  // Body text of the comment
  final String commentBody;

  // URL of the commenter's profile image
  final String commenterImageUrl;

  // Constructor for CommentWidget
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

// State class for CommentWidget
class _CommentWidgetState extends State<CommentWidget> {
  // List of colors for comment avatar borders
  final List<Color> _colors = [
    Colors.blueAccent,
    Colors.blue,
    Colors.lightBlue,
    Colors.blueGrey,
    Colors.white60,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    // Shuffle the colors for variety
    _colors.shuffle();

    return InkWell(
      onTap: () {
        // Handle tap on the comment if needed
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Commenter's profile image
          Flexible(
            flex: 1,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: _colors[1],
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.commenterImageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6,),
          // Commenter's name and comment body
          Flexible(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display commenter's name
                Text(
                  widget.commenterName,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                // Display comment body
                Text(
                  widget.commentBody,
                  style: const TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 13,
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
