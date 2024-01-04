import 'package:app_jobdirect/firebase_options.dart';
import 'package:app_jobdirect/screens/authenticate/register.dart';
import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/home/splash_screen.dart';
import 'package:app_jobdirect/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  // Initialize Firebase before runApp
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Job Finder App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DashboardScreen(), // Display the splash screen initially
        routes: {
          '/wrapper': (context) => const Wrapper(), // Replace DashboardScreen with your actual dashboard screen
        },
      );
  }
}
