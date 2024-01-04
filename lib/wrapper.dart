import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:app_jobdirect/screens/authenticate/toggle_auth.dart';
import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //           body: Center(
  //             child: ToggleAuth(),
  //           ),
  //         );
  //
  // }

  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(ctx, usersnapshot) {
          if(usersnapshot.data == null) {
            print("not logged");
            return ToggleAuth();
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
