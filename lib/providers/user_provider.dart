// Importing necessary packages
import 'package:flutter/material.dart';

// A class to provide user-related information using ChangeNotifier for state management
class UserProvider extends ChangeNotifier {
  // User attributes
  String? name;         // User's name
  String? contact;      // User's contact information
  String? education;    // User's education details
  String? address;      // User's address
  String? password;     // User's password

  // Method to update user profile information
  void updateProfile({
    String? name,
    String? contact,
    String? education,
    String? address,
    String? password,
  }) {
    // Updating the user attributes with the provided information
    this.name = name;
    this.contact = contact;
    this.education = education;
    this.address = address;
    this.password = password;

    // Notifying listeners about the change in user profile
    notifyListeners();
  }
}
