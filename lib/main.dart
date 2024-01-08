// Import necessary packages and files
import 'package:app_jobdirect/firebase_options.dart';
import 'package:app_jobdirect/providers/user_provider.dart';
import 'package:app_jobdirect/screens/home/splash_screen.dart';
import 'package:app_jobdirect/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  // Initialize Firebase before runApp
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the application, providing a UserProvider to the widget tree
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Build the root of the application using MaterialApp
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Finder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(), // Display the splash screen initially
      debugShowCheckedModeBanner: false,
      routes: {
        '/wrapper': (context) => const Wrapper(), // Replace DashboardScreen with your actual dashboard screen
      },
    );
  }
}
