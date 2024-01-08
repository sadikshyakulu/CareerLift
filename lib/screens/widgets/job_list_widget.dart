import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/global_variables.dart';

class JobListWidget{
  static List<String> jobCategoryList = [
    'Art',
    'Education',
    'Software-Programming',
    'Hardware'
  ];
  void getData()async{
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    name = userDoc.get("name");
    userImage=userDoc.get("userImage");
    address=userDoc.get("address");
  }
}