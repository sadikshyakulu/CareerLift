// Importing necessary packages from the Flutter framework
import 'package:flutter/material.dart';

// A class containing global methods that can be used throughout the application
class GlobalMethods {
  // Method to display an error dialog with a given error message and context
  static void showErrorDialog({required String error, required BuildContext ctx}) {
    showDialog(
      context: ctx,
      builder: (context) {
        // Creating an AlertDialog to show the error message
        return AlertDialog(
          title: const Row(
            children: [
              // Icon representing an error
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.logout,
                  size: 22,
                ),
              ),
              // Text indicating the presence of an error
              Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  "Shhh! There's an Error",
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          // Displaying the error message in the content of the dialog
          content: Text(
            error,
          ),
          // Adding an "OK" button to dismiss the dialog
          actions: [
            TextButton(
              onPressed: () {
                // Dismissing the dialog when the "OK" button is pressed
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
