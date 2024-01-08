import 'dart:io';

import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:app_jobdirect/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';




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
  File? fileImage;

  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _emailController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  final TextEditingController _contactController = TextEditingController(text: "");
  final TextEditingController _addressController = TextEditingController(text: "");
  final TextEditingController _educationController = TextEditingController(text: "");

  bool loading = false;
  // text field state
  String err = '';
  String email = '';
  String password = '';
  String name = '';
  String contact = '';
  String address ='';
  String education='';

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
    _educationController.dispose();
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
          'education': _educationController.text,
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

  void _imageFromCamera() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropPickedImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _imageFromGallery() async
  {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropPickedImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropPickedImage(filePath) async
  {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: filePath, maxHeight: 1080, maxWidth: 1080
    );
    if(croppedImage != null)
    {
      setState(() {
        fileImage = File(croppedImage.path);
      });
    }
  }

  void _showImageDialog(){
    showDialog(
        context: context,
        builder: (context)
        {
          return AlertDialog(
            title: Text('What would you like to do'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    _imageFromCamera();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.camera,
                        ),
                      ),
                      Text(
                          "Camera"
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    _imageFromGallery();
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.photo_album,
                        ),
                      ),
                      Text(
                          "Gallery"
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
    );
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
                          Padding(
                            padding: const EdgeInsets.only(top:40),
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
                                height: size.height *0.9,
                                width: size.width *0.85 ,
                                child: SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 3),
                                        Center(
                                          child: GestureDetector(
                                            onTap: (){
                                              _showImageDialog();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Container(
                                                width: size.width * 0.24,
                                                height: size.height * 0.24,
                                                decoration: BoxDecoration(
                                                    border: Border.all(width: 1, color: Colors.cyanAccent),
                                                    borderRadius: BorderRadius.circular(20)
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(16),
                                                  child: fileImage == null
                                                      ? Icon(Icons.camera, color: Colors.white, size: 30,)
                                                      : Image.file(fileImage!, fit: BoxFit.fill,),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
                                        buildInputField('Education', (val) {
                                          setState(() => education = val);
                                        }, _educationController
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
