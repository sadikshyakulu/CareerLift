import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:app_jobdirect/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class Register extends StatefulWidget {

  final Function? toggleView; // Use Function?

  const Register({super.key, this.toggleView});


  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  //final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _emailController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  final TextEditingController _contactController = TextEditingController(text: "");
  final TextEditingController _addressController = TextEditingController(text: "");

  bool loading = false;
  // text field state
  String err = '';
  String email = '';
  String password = '';
  String name = '';
  String contact = '';
  String address ='';

  bool obscurePassword = true; // State variable for password visibility

  @override
  void initState() {
    super.initState();
  }

  void disppose(){
    _addressController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  void  _submitRegisteration() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        loading = true;
      });

      try {
        await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.trim().toLowerCase(),
            password: _passwordController.text.trim()
        );
        final User? user = _auth.currentUser;
        final _uid = user!.uid;
        final ref = FirebaseStorage.instance.ref().child("userImages").child(
            _uid + '.jpg');
        // await ref.putFile(imageFile!);
        FirebaseFirestore.instance.collection("Users")
            .doc(_uid).set({
          'uid': _uid,
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
          'contact': _contactController.text,
          'address': _addressController.text,
          'createdAt': Timestamp.now(),
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      }catch (err) {
        setState(() {
          loading = false;
        });
        GlobalMethods.showErrorDialog(
            error: err.toString(),
            ctx:context
        );
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildInputField(String hintText, void Function(String) onChanged, TextEditingController control) {
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
        controller: control,
        obscureText: hintText == 'Password' ? obscurePassword : false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          labelText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          suffixIcon: hintText == 'Password' ? GestureDetector(
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


    return loading ? const Loading() : Scaffold(
        backgroundColor: Colors.blueGrey[100],

        body: SizedBox(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                    children: [
                      //image logo
                      Stack(
                        children: [
                          Container(
                              height: 637,
                              width: size.width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(100.0), // Adjust the radius as needed
                                  bottomRight: Radius.circular(100.0), // Adjust the radius as needed
                                ),
                                //  can also set other properties of BoxDecoration here if needed
                                gradient: LinearGradient(
                                  colors: [Color(0xFF429690), Color(0xFF2A7C76)], //  list of colors
                                  begin: Alignment.topCenter, // the starting point
                                  end: Alignment.bottomCenter, // the ending point
                                  stops: [0.0, 0.7], //  stops for each color
                                  //  can also use 'stops' to define where each color should blend
                                  // Stops, if not provided, distribute colors evenly across the gradient.
                                ),
                              ),
                              child:Column(
                                children: [
                                  Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: ClipRect(
              
                                          child: Image.asset(
                                            "assets/Group 21_large.png",
                                            fit: BoxFit.cover,
                                          ),
              
                                        ),
                                      ),
              
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:300),
                                          child: Text("Create your account",style:GoogleFonts.poppins(color:Colors.white,fontSize: 32,fontWeight: FontWeight.w600,)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:10),
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              height: 242,
                                              width: 247,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.black.withOpacity(0.2), // Change the opacity level here (0.0 - 1.0)
                                              ),
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
                                ],
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:384),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1B5C58),
                                    borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5), // Shadow color
                                      spreadRadius: 5, // Spread radius
                                      blurRadius: 7, // Blur radius
                                      offset: const Offset(0, 4), // Offset/direction of shadow
                                    ),
                                  ],
                                ),
                                height: size.height *0.83,
                                width: size.width *0.85 ,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 3),
                                      buildInputField('Name', (val) {
                                        setState(() => name = val);
                                      }, _nameController
                                      ),
                                      const SizedBox(height: 3),
                                      buildInputField('Address', (val) {
                                        setState(() => address = val);
                                      }, _addressController
                                      ),
                                      const SizedBox(height: 3),
                                      buildInputField('Contact', (val) {
                                        setState(() => contact = val);
                                      }, _contactController
                                      ),
                                      const SizedBox(height: 3),
                                      buildInputField('Email', (val) {
                                        setState(() => email = val);
                                      }, _emailController
                                      ),
                                      const SizedBox(height: 3),
                                      buildInputField('Password', (val) {
                                        setState(() => password = val);
                                      }, _passwordController
                                      ),
                                      const SizedBox(height: 3),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            // Handle sign-in logic
                                            _submitRegisteration();
                                            // if (_formKey.currentState?.validate() ?? false) {
                                            //   setState(() => loading = true);
                                            //   // dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                                            //   // if (result == null) {
                                            //   //   setState(() => err = 'Please set a valid email and password');
                                            //   //   loading = false;
                                            //   // }
                                            // }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30),
              
                                            ),
                                          ),
                                          child: const Text('Sign Up'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height/35,
                                      ),
                                      Center(
                                        child: Text(
                                          err,
                                          style: const TextStyle(
                                              color: Colors.red
                                          ),
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
                      SizedBox(
                        width: size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account ?",style:GoogleFonts.workSans(color:const Color(0xFF000000),fontSize: 16)),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(context,MaterialPageRoute(builder:(_) => SignIn()));
                                  },
                                  icon: const Icon(Icons.person),
                                ),
                                Text('Sign In',style:GoogleFonts.poppins(color:const Color(0xFF265A89),fontSize: 16,fontWeight: FontWeight.w600,decoration: TextDecoration.underline)),
                              ],
                            )
                          ],
                        ),
                      )
                    ]),
              ),
            )
        )
    );
  }
}
