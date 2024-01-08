import 'package:app_jobdirect/screens/authenticate/forgot_password.dart';
import 'package:app_jobdirect/screens/authenticate/register.dart';
import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:app_jobdirect/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView; // Use Function?

  SignIn({this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController =
  TextEditingController(text: '');
  final TextEditingController _passwordController =
  TextEditingController(text: '');

  // Text field state
  String email = '';
  String password = '';
  String err = '';
  bool obscurePassword = true; // State variable for password visibility

  @override
  void initState() {
    super.initState();
  }

  // Handles the sign-in form submission
  void _signInSubmit() async {
    final validData = _formKey.currentState!.validate();
    if (validData) {
      setState(() {
        loading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      } catch (err) {
        setState(() {
          loading = false;
        });
        GlobalMethods.showErrorDialog(error: err.toString(), ctx: context);
        print(err);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // Build individual input fields
    Widget buildInputField2(String hintText, void Function(String) onChanged,
        TextEditingController controltext) {
      return TextFormField(
        validator: (val) {
          if (val!.isEmpty) {
            return 'Enter a $hintText';
          } else if (val.length < 6 && hintText == 'Password') {
            return 'Enter a password 6 characters or longer';
          }
          return null;
        },
        onChanged: onChanged,
        obscureText: hintText == 'Password' ? obscurePassword : false,
        controller: controltext,
        decoration: InputDecoration(
          // Input field decoration
          fillColor: Colors.white,
          filled: true,
          labelText: hintText,
          labelStyle: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: hintText == 'Password'
              ? GestureDetector(
            onTap: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            child: Icon(
              obscurePassword
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.black,
            ),
          )
              : null,
        ),
      );
    }

    return loading
        ? Loading()
        : Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              Stack(
                children: [
                  Container(
                    height: 637,
                    width: size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100.0),
                        bottomRight: Radius.circular(100.0),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF429690),
                          Color(0xFF2A7C76),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 0.7],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Widgets for the top section of the screen
                        // including logo and welcome text
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 384),
                    child: Center(
                      child: Container(
                        // Container for the sign-in form
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xFF1B5C58),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        height: size.height * 0.5,
                        width: size.width * 0.85,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Input fields and buttons for sign-in form
                              SizedBox(height: size.height / 35),
                              buildInputField2(
                                  'Email',
                                      (val) {
                                    setState(() => email = val);
                                  },
                                  _emailController),
                              SizedBox(height: size.height / 35),
                              buildInputField2(
                                  'Password',
                                      (val) {
                                    setState(() => password = val);
                                  },
                                  _passwordController),
                              SizedBox(height: size.height / 35),
                              Row(
                                children: [
                                  SizedBox(width: 30),
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ForgotPassword()));
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration
                                              .underline,
                                          decorationColor:
                                          Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: _signInSubmit,
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(30),
                                        ),
                                      ),
                                      child: const Text('Sign In'),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height / 35,
                              ),
                              Center(
                                child: Text(
                                  err,
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Widgets for the bottom section of the screen
              // including registration link and icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don’t have an account ?",
                      style: GoogleFonts.workSans(
                          color: Color(0xFF000000), fontSize: 16)),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => Register()));
                          },
                          icon: Icon(Icons.person)),
                      Text(
                          'Register',
                          style: GoogleFonts.poppins(
                              color: Color(0xFF265A89),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline)),
                    ],
                  )
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
