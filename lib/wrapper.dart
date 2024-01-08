// Import necessary packages and files
import 'package:app_jobdirect/screens/authenticate/toggle_auth.dart';
import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Wrapper class responsible for handling the authentication state
class Wrapper extends StatelessWidget {
  // Constructor for the Wrapper class
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // StreamBuilder to listen to changes in the authentication state
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, usersnapshot) {
        // Check if the user is not logged in
        if (usersnapshot.data == null) {
          print("User not logged in");
          return ToggleAuth(); // Display authentication toggle screen
        }
        // Check if the user is logged in
        else if (usersnapshot.hasData) {
          print("User logged in");
          return DashboardScreen(); // Display the main dashboard screen
        }
        // Check if there is an error in the authentication process
        else if (usersnapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error occurred during authentication"),
            ),
          );
        }
        // Check if the authentication state is still waiting
        else if (usersnapshot.connectionState == ConnectionState.waiting) {
          print("Authentication state is waiting");
          return Loading(); // Display a loading animation
        }

        // Default case: Display an error message if something unexpected happens
        return Scaffold(
          body: Center(
            child: Text("Something went wrong"),
          ),
        );
      },
    );
  }
}
