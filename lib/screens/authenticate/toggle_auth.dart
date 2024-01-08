// Importing necessary packages and files
import 'package:app_jobdirect/screens/authenticate/register.dart';
import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

// Class responsible for toggling between sign-in and register screens
class ToggleAuth extends StatefulWidget {
  const ToggleAuth({Key? key}) : super(key: key);

  @override
  State<ToggleAuth> createState() => _ToggleAuthState();
}

class _ToggleAuthState extends State<ToggleAuth> {
  // Variable to track whether to show sign-in or register screen
  bool showSignIn = true;

  // Function to toggle between sign-in and register screens
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    // Conditional rendering based on the value of showSignIn
    if (showSignIn) {
      // Display the sign-in screen if showSignIn is true
      return SignIn(toggleView: toggleView);
    } else {
      // Display the register screen if showSignIn is false
      return Register(toggleView: toggleView);
    }
  }
}
