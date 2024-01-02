import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:app_jobdirect/screens/home/dashboard.dart';
import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserState extends StatelessWidget {
  const UserState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(ctx, usersnapshot) {
          if(usersnapshot.data == null) {
            print("not logged");
            return SignIn();
          } else if(usersnapshot.hasData) {
            print("logged in");
            return DashboardScreen();
          } else if(usersnapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("err"),
              ),
            );
          } else if(usersnapshot.connectionState == ConnectionState.waiting) {
            print("logged in");
            return Loading();
          }
          return Scaffold(
            body: Center(
              child: Text("somthing not right"),
            ),
          );
        }

    );
  }
}
