import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {


  @override
  State<ForgotPassword> createState()=>_forgotPasswordState();

}
class _forgotPasswordState extends State<ForgotPassword>{

  final TextEditingController _forgotPasswordController = TextEditingController(text:"");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _forgotPassSubmit()async{
    try{
      await _auth.sendPasswordResetEmail(
        email: _forgotPasswordController.text,);
      Navigator.pushReplacement(context,MaterialPageRoute(builder:(_) => SignIn()));
    }
    catch (error){
      Fluttertoast.showToast(msg: error.toString());
    }

  }
  @override
  Widget build(BuildContext context){
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
                      Stack(
                        children: [
                          Container(
                              height: size.height/1.2,
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
                                          child: Text("Forgot Password",style:GoogleFonts.poppins(color:Colors.white,fontSize: 32,fontWeight: FontWeight.w600, )),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:180,left: 40),
                                        child: Text("Enter Your Email address",style:GoogleFonts.poppins(color:Colors.white,fontSize: 20)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:220,left: 30),
                                        child: Container(
                                          width: size.width/1.2,
                                          child: TextFormField(
                                            controller: _forgotPasswordController,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: UnderlineInputBorder(
                                                borderRadius: BorderRadius.circular(40),
                                                borderSide: const BorderSide(color:Colors.white),
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
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top:300),
                                          child: ElevatedButton(
                                            onPressed: (){
                                              _forgotPassSubmit();

                                            },

                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF59C0CE), // Change the color here
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),

                                              ),
                                            ),
                                            child: Text('Reset',style:GoogleFonts.poppins(fontSize: 28, )),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top:360,left:20),
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
                              )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:750),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Remember my Password",style:GoogleFonts.workSans(color:Colors.black,fontSize: 16,)),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(context,MaterialPageRoute(builder:(_) => SignIn()));
                                        },
                                        icon: const Icon(Icons.person)
                                    ),
                                    Text('Sign In',style:GoogleFonts.poppins(color:Color(0xFF265A89),fontSize: 16,fontWeight: FontWeight.w600,decoration: TextDecoration.underline)),
                                  ],
                                )

                              ],
                            ),
                          )


                        ],
                      ),




                    ]),
              ),
            )
        )
    );
  }
}