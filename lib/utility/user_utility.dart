import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserUtility {
  static Future<void> updateDetails(
      FirebaseAuth auth,
      FirebaseFirestore firestore,
      String userId,
      String name,
      String contact,
      String education,
      String address,
      String password,
      ) async {
    await firestore.collection('Users').doc(userId).update({
      'name': name,
      'contact': contact,
      'education': education,
      'address': address,
      'password': password,
    });
  }
}