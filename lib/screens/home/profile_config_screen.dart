import 'dart:io';
import 'dart:math';

import 'package:app_jobdirect/screens/widgets/bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileConfiguration extends StatefulWidget {
  const ProfileConfiguration({Key? key});

  @override
  State<ProfileConfiguration> createState() => _ProfileConfigurationState();
}

class _ProfileConfigurationState extends State<ProfileConfiguration> {
  final _profileKey = GlobalKey<FormState>();
  File? imageFile;

  bool obscurePassword = true;

  String email =  '';
  String password = '';
  String name='';
  String address='';
  String education='';
  String ocupation='';
  String err = '';

  // Use TextEditingController for each TextFormField
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode _nameFocus=FocusNode();
  FocusNode _contactFocus=FocusNode();
  FocusNode _educationFocus=FocusNode();
  FocusNode _addressFocus=FocusNode();
  FocusNode _emailFocus=FocusNode();
  FocusNode _passwordFocus=FocusNode();

  void _showImage(){
    showDialog(
        context: context, builder: (context){
          return AlertDialog(
            title: Text('Please choose an option',style:GoogleFonts.inter(color:Colors.black,fontWeight:FontWeight.bold, ),),
            content: Column(
              mainAxisSize:MainAxisSize.min ,
              children: [
                InkWell(
                  onTap: (){
                    //create get from camera
                    _getImageFromCamera();
                  },
                  child: Row(
                    children: [
                      const Padding(
                          padding:EdgeInsets.all(7) ,
                        child:
                          Icon(
                            Icons.camera_alt_sharp,
                            color:Colors.black,

                          )
                      ),
                      Text("Camera",style:GoogleFonts.inter(color:Colors.black,fontWeight:FontWeight.bold, ),),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    //create get from gallery
                    _getImageFromGallery();
                  },
                  child: Row(
                    children: [
                      const Padding(
                          padding:EdgeInsets.all(7) ,
                          child:
                          Icon(
                            Icons.image_aspect_ratio_sharp,
                            color:Colors.black,

                          )
                      ),
                      Text("Gallery",style:GoogleFonts.inter(color:Colors.black,fontWeight:FontWeight.bold, ),),
                    ],
                  ),
                )
              ],

            ),

          );
    },
    );
  }
  void _getImageFromCamera()async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }
  void _getImageFromGallery()async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  void _cropImage(filePath) async {
    try {
      CroppedFile? cropImage = await ImageCropper().cropImage(
        sourcePath: filePath,
        maxHeight: 1080,
        maxWidth: 1080,
      );

      if (cropImage != null) {
        setState(() {
          imageFile = File(cropImage.path);
        });
      }
    } catch (e) {
      print('Error while cropping image: $e');
      // Implement proper error handling, such as showing an error message
    }
  }




  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget buildTextFormField({
      required TextEditingController controller,
      required String labelText,
      TextInputType keyboardType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.done,
      FocusNode? focusNode,
      FocusNode? nextFocusNode,
      FormFieldValidator<String>? validator,
    }) {
      return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: focusNode,
        onEditingComplete: () {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            // Hide keyboard if next focus node is not available
            FocusScope.of(context).unfocus();
          }
        },
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFD9D9D9),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
    Widget buildInputField2(String hintText, void Function(String) onChanged,{FocusNode? focusNode,
        FocusNode? nextFocusNode,} ) {
      return TextFormField(
        validator: (val) {
          if (val!.isEmpty) {
            return 'Enter a $hintText';
          } else if (val.length < 6 && hintText == 'Password') {
            return 'Enter a password 6 characters or longer';
          }
          return null;
        },
        focusNode: focusNode,
        onEditingComplete: () {
          if (nextFocusNode != null) {
            FocusScope.of(context).requestFocus(nextFocusNode);
          } else {
            // Hide keyboard if next focus node is not available
            FocusScope.of(context).unfocus();
          }
        },
        onChanged: onChanged,
        obscureText: hintText == 'Password' ? obscurePassword : false,
        decoration: InputDecoration(
          fillColor: const Color(0xFFD9D9D9),
          filled: true,
          labelText: hintText, // Added labelText for clarity
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular( 10),
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

    return Scaffold(
      backgroundColor: const Color(0xFF2D7F79),
      bottomNavigationBar: BottomNavbar(indexNum: 3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D7F79),
        title: Center(child: Text('Edit Profile',style:GoogleFonts.poppins(color:Colors.white,fontSize: 32,fontWeight: FontWeight.w600, ))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: SingleChildScrollView(
          child: Column(

            children: [
              Padding(
                padding: const EdgeInsets.only(top:9),
                child: Form(
                  key: _profileKey,
                  child: Column(

                    children: [
                      GestureDetector(
                        onTap: () async {
                          _showImage();
                        },

                        child: Padding(
                          padding: const EdgeInsets.only(top:9),
                          child: Container(
                            width: size.width * 0.4,
                            height: size.width * 0.4, // Set a square container
                            decoration: BoxDecoration(
                              border:Border.all(width: 1,color:Colors.cyanAccent),
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: imageFile == null
                                  ? Image.asset(
                                'assets/editPerson.png',
                               fit: BoxFit.fill,
                               )

                                  : Image.file(
                                imageFile!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Center(child: Text("Profile picture",style:GoogleFonts.poppins(color:Colors.white,fontSize: 20,fontWeight: FontWeight.w600, ))),
              SizedBox(height: size.height/35),
              buildTextFormField(
                controller: _nameController,
                labelText: 'Name',
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                focusNode: _nameFocus,
                nextFocusNode: _emailFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
              SizedBox(height:size.height/35),
              buildInputField2('Email',focusNode: _emailFocus,
                  nextFocusNode: _passwordFocus,  (val) {
                setState(() => email = val);
              }),
              SizedBox(height: size.height/35),
              buildInputField2('Password',focusNode: _passwordFocus,
                  nextFocusNode: _contactFocus, (val) {
                setState(() => password = val);
              }),
              SizedBox(height: size.height/35),
              buildTextFormField(
                controller: _contactController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                focusNode: _contactFocus,
                nextFocusNode:_educationFocus ,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height/35),
              buildTextFormField(
                controller: _educationController,
                labelText: 'Education',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _educationFocus,
                nextFocusNode:_addressFocus,
                  validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height/35),
              buildTextFormField(
                controller: _addressController,
                labelText: 'Address',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _addressFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height/30),
              Center(
                child: ElevatedButton(
                  onPressed: (){},
                  //     () async {
                  //   // Handle sign-in logic
                  //   // if (_formKey.currentState?.validate() ?? false) {
                  //   //   setState(() => loading = true
                  //   //   );
                  //   //   // dynamic result = await _auth.signinWithEmailAndPassword(email, password);
                  //   //   // if (result == null) {
                  //   //   //   setState(() => err = 'Could not sign in with the credentials');
                  //   //   //   loading = false;
                  //   //   // }
                  //   // }
                  //
                  // },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child:  Text('Save',style:GoogleFonts.inter(color:Colors.black,fontSize: 30,fontWeight:FontWeight.bold, ),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
