// ADD THIS INSIDE YOUR UserUtility CLASS
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserUtility {
  // ... your existing methods (updateDetails, etc.)

  // ADD THIS METHOD — IMAGE UPLOAD TO FIREBASE STORAGE
  static Future<String> uploadProfileImage(File imageFile, String userId) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profile_images')
          .child('$userId.jpg');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      print("Profile image uploaded: $downloadUrl");
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      rethrow;
    }
  }

  // Your existing updateDetails method should also update the image URL
  static Future<void> updateDetails(
      FirebaseAuth auth,
      FirebaseFirestore firestore,
      String userId,
      String name,
      String contact,
      String education,
      String address,
      String password, {
        String? profileImageUrl, // Add this optional parameter
      }) async {
    try {
      Map<String, dynamic> updateData = {
        'name': name,
        'contact': contact,
        'education': education,
        'address': address,
      };

      if (password.isNotEmpty) {
        updateData['password'] = password;
        await auth.currentUser?.updatePassword(password);
      }

      if (profileImageUrl != null) {
        updateData['userImage'] = profileImageUrl;
      }

      await firestore.collection('Users').doc(userId).update(updateData);
    } catch (e) {
      print("Error updating profile: $e");
      rethrow;
    }
  }
}