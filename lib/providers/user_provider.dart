import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? name;
  String? contact;
  String? education;
  String? address;
  String? password;

  void updateProfile({
    String? name,
    String? contact,
    String? education,
    String? address,
    String? password,
  }) {
    this.name = name;
    this.contact = contact;
    this.education = education;
    this.address = address;
    this.password = password;
    notifyListeners();
  }
}