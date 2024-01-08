// Import necessary packages and files
import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

// Define the ForgotPassword widget
class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

// Define the state for the ForgotPassword widget
class _ForgotPasswordState extends State<ForgotPassword> {
  // Controller for the email input field
  final TextEditingController _forgotPasswordController =
  TextEditingController(text: "");
  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle password reset submission
  void _forgotPassSubmit() async {
    try {
      await _auth.sendPasswordResetEmail(email: _forgotPasswordController.text);
      // Navigate to the Sign In screen after successful password reset email
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn()));
    } catch (error) {
      // Display an error toast if password reset fails
      Fluttertoast.showToast(msg: error.toString());
    }
  }

  // Build the ForgotPassword widget
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                // Background container with gradient and images
                Stack(
                  children: [
                    Container(
                      height: size.height / 1.2,
                      width: size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100.0),
                          bottomRight: Radius.circular(100.0),
                        ),
                        gradient: LinearGradient(
                          colors: [Color(0xFF429690), Color(0xFF2A7C76)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 0.7],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Content for the password reset screen
                          Stack(
                            children: [
                              // Logo and title
                              Align(
                                alignment: Alignment.topLeft,
                                child: ClipRect(
                                  child: Image.asset(
                                    "assets/Group 21_large.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 41),
                                  child: Text(
                                    "Forgot Password",
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 180, left: 40),
                                child: Text(
                                  "Enter Your Email address",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              // Email input field
                              Padding(
                                padding: const EdgeInsets.only(top: 220, left: 30),
                                child: Container(
                                  width: size.width / 1.2,
                                  child: TextFormField(
                                    controller: _forgotPasswordController,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: const BorderSide(color: Colors.white),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Reset button
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 300),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _forgotPassSubmit();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF59C0CE),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      'Reset',
                                      style: GoogleFonts.poppins(fontSize: 28),
                                    ),
                                  ),
                                ),
                              ),
                              // Image at the bottom
                              Padding(
                                padding: const EdgeInsets.only(top: 360, left: 20),
                                child: ClipRect(
                                  child: Image.asset(
                                    "assets/forgot_img.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Remember password and Sign In link
                    Padding(
                      padding: const EdgeInsets.only(top: 750),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remember my Password",
                            style: GoogleFonts.workSans(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Navigate to the Sign In screen
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignIn()));
                                },
                                icon: const Icon(Icons.person),
                              ),
                              Text(
                                'Sign In',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF265A89),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
