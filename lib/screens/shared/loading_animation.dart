import 'package:flutter/material.dart';

// Loading Widget: A simple loading indicator to display when data is being fetched.

class Loading extends StatelessWidget {
  // Constructor for the Loading widget.
  const Loading({Key? key}) : super(key: key);

  // Build method to create the widget UI.
  @override
  Widget build(BuildContext context) {
    return Container(
      // Container to hold the loading indicator at the center of the screen.
      child: Center(
        child: CircularProgressIndicator(
          // CircularProgressIndicator to indicate that a process is ongoing.
          color: Colors.teal,  // Color customization for the loading indicator.
        ),
      ),
    );
  }
}
