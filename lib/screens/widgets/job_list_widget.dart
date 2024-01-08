import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Importing global variables from services
import '../../services/global_variables.dart';

// Class representing the JobListWidget
class JobListWidget {
  // Static list of job categories
  static List<String> jobCategoryList = [
    'Art',
    'Education',
    'Software-Programming',
    'Hardware',
    'Human Resource',
    'Labour',
    'HealthCare',
    'Fashion',
    'Designing',
  ];

  // Method to fetch user data from Firestore
  void getData() async {
    // Retrieve the document snapshot for the current user
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // Update global variables with user data
    name = userDoc.get("name");
    userImage = userDoc.get("userImage");
    address = userDoc.get("address");
  }
}
