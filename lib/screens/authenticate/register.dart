import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';




class Register extends StatefulWidget {

  final Function? toggleView; // Use Function?

  Register({this.toggleView});


  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  //final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  // text field state
  String err = '';
  String email = '';
  String password = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    Widget buildInputField(String hintText, bool obscure, void Function(String) onChanged) {
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
        obscureText: obscure,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: hintText, // Added labelText for clarity
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    }


    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.blueGrey[100],

        body: SizedBox(
            width: size.width,
            height: size.height,
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
                                  color: Color(0xFF1B5C58),
                                  borderRadius: BorderRadius.circular(30)),
                              height: 350,
                              width: 354 ,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: size.height/35),

                                    buildInputField('Email', false, (val) {
                                      setState(() => email = val);
                                    }),
                                    SizedBox(height: size.height/38),
                                    buildInputField('Password', true, (val) {
                                      setState(() => password = val);
                                    }),
                                    SizedBox(height: size.height/35),
                                    Center(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          // Handle sign-in logic
                                          if (_formKey.currentState?.validate() ?? false) {
                                            setState(() => loading = true);
                                            // dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                                            // if (result == null) {
                                            //   setState(() => err = 'Please set a valid email and password');
                                            //   loading = false;
                                            // }
                                          }
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
                                        style: TextStyle(
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
                    Container(
                      width: size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account ?",style:GoogleFonts.workSans(color:Color(0xFF000000),fontSize: 16)),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.toggleView!();
                                },
                                icon: Icon(Icons.person),
                              ),
                              Text('Sign In',style:GoogleFonts.poppins(color:Color(0xFF265A89),fontSize: 16,fontWeight: FontWeight.w600,decoration: TextDecoration.underline)),
                            ],
                          )

                        ],
                      ),

                    )


                  ]),
            )
        )
    );
  }
}
