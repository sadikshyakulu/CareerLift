import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// A utility class for managing user-related operations with Firebase.
class UserUtility {
  /// Updates the details of a user in the Firestore database.
  ///
  /// [auth] is the FirebaseAuth instance.
  /// [firestore] is the FirebaseFirestore instance.
  /// [userId] is the unique identifier of the user.
  /// [name] is the updated name of the user.
  /// [contact] is the updated contact information of the user.
  /// [education] is the updated educational background of the user.
  /// [address] is the updated address of the user.
  /// [password] is the updated password of the user.
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
    // Update the user details in the 'Users' collection of Firestore.
    await firestore.collection('Users').doc(userId).update({
      'name': name,
      'contact': contact,
      'education': education,
      'address': address,
      'password': password,
    });
  }
}
