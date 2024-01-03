import 'package:app_jobdirect/screens/authenticate/forgot_password.dart';
import 'package:app_jobdirect/screens/authenticate/register.dart';
import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {

  final Function? toggleView; // Use Function?

  SignIn({this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;


  // text field state
  String email =  '';
  String password = '';
  String err = '';

  bool obscurePassword = true; // State variable for password visibility

  @override
  void initState() {
    super.initState();
  }
  // void _signInSubmit()async{
  //   final validData = _formKey.currentState!.validate();
  //   if(validData){
  //     setState(() {
  //       loading=true;
  //     });
  //     try{
  //       await _
  //
  //     }
  //   }
  // }
  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    Widget buildInputField2(String hintText, void Function(String) onChanged) {
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
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: hintText, // Added labelText for clarity
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

    return loading ? Loading() : Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SizedBox(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(

              child: Center(
                child: Column(
                    children: [
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
                                          padding: const EdgeInsets.only(top:41),
                                          child: Text("Welcome",style:GoogleFonts.poppins(color:Colors.white,fontSize: 32,fontWeight: FontWeight.w600, )),
                                        ),
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:108),
                                          child: Text("Login to your account",style:GoogleFonts.workSans(color:Colors.white,fontSize: 20)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:143),
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
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5), // Shadow color
                                      spreadRadius: 5, // Spread radius
                                      blurRadius: 7, // Blur radius
                                      offset: Offset(0, 4), // Offset/direction of shadow
                                    ),
                                  ],


                                ),
                                height: 350,
                                width: 354 ,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height:size.height/35),
                                      buildInputField2('Email',  (val) {
                                        setState(() => email = val);
                                      }),
                                      SizedBox(height: size.height/35),
                                      buildInputField2('Password', (val) {
                                        setState(() => password = val);
                                      }),
                                      SizedBox(height: size.height/35),
                                      Row(
                                        children: [
                                          SizedBox(width: 30,),
                                          Align(
                                            alignment:Alignment.bottomLeft,
                                            child: TextButton(
                                              onPressed:(){
                                                Navigator.push(context,MaterialPageRoute(builder: (context)=> ForgotPassword()));

                                              },
                                              child:Text(
                                                "Forgot Password?",
                                                style: GoogleFonts.poppins(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  decoration: TextDecoration.underline, decorationColor: Color(0xFFFFFFFF),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                // Handle sign-in logic
                                                if (_formKey.currentState?.validate() ?? false) {
                                                  setState(() => loading = true
                                                  );
                                                  // dynamic result = await _auth.signinWithEmailAndPassword(email, password);
                                                  // if (result == null) {
                                                  //   setState(() => err = 'Could not sign in with the credentials');
                                                  //   loading = false;
                                                  // }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30),
                                                ),
                                              ),
                                              child: const Text('Sign In'),
                                            ),
                                          ),
                                        ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don’t have an account ?",style:GoogleFonts.workSans(color:Color(0xFF000000),fontSize: 16)),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(context,MaterialPageRoute(builder:(_) => Register()));
                                  },
                                  icon: Icon(Icons.person)
                              ),
                              Text('Register',style:GoogleFonts.poppins(color:Color(0xFF265A89),fontSize: 16,fontWeight: FontWeight.w600,decoration: TextDecoration.underline)),
                            ],
                          )

                        ],
                      )
                      //image logo


                    ]),
              ),
            )
        )
    );
  }
}
