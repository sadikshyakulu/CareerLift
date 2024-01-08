import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    //Simulate loading process
    Future.delayed(const Duration(seconds: 5), () {


      //Navigate to the dashboard after loading
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushReplacementNamed(context, '/wrapper');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool forAndroid = size.width < 450;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 488,
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(100.0),
                bottomRight: Radius.circular(100.0),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF429690), Color(0xFF2A7C76)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.7],
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: ClipRect(
                    child: Image.asset(
                      "assets/Group 21.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 210),
                    child: Container(
                      height: 242,
                      width: 247,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Container(
            height: 350,
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100.0),
                topRight: Radius.circular(100.0),
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF2A7C76), Color(0xFF429690)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.7],
              ),
            ),
            child: Column(
              children: [
                Text(
                  "JobDirect",
                  style: GoogleFonts.jomhuria(
                    color: const Color(0xFF004F5C),
                    fontSize: 96,
                  ),
                ),
                forAndroid ? AndroidLayout() : PCLayout(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF429690), Color(0xFF2A7C76)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.7],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Center(
                  child: Text(
                    "Loading ..........",
                    style: GoogleFonts.jomhuria(
                      color: Colors.white.withOpacity(0.56),
                      fontSize: 34,
                      height: 0.8,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget AndroidLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        children: [
          // Add Android layout widgets here if needed
        ],
      ),
    );
  }

  Widget PCLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          // Add PC layout widgets here if needed
        ],
      ),
    );
  }
}
