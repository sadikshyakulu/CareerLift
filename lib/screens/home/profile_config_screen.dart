import 'dart:io';

import 'package:app_jobdirect/screens/widgets/bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  TextEditingController _ageController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();

  FocusNode _contactFocus=FocusNode();
  FocusNode _educationFocus=FocusNode();
  FocusNode _addressFocus=FocusNode();
  FocusNode _ocupationFocus=FocusNode();

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
          fillColor: Color(0xFFD9D9D9),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
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
          fillColor: Color(0xFFD9D9D9),
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
      backgroundColor: Color(0xFF2D7F79),
      bottomNavigationBar: BottomNavbar(indexNum: 3),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D7F79),
        title: Center(child: Text('Edit Profile',style:GoogleFonts.poppins(color:Colors.white,fontSize: 32,fontWeight: FontWeight.w600, ))),
      ),
      body: Padding(
        padding: EdgeInsets.all(7.0),
        child: SingleChildScrollView(
          child: Column(

            children: [
              Padding(
                padding: EdgeInsets.only(top:9),
                child: Form(
                  key: _profileKey,
                  child: Column(

                    children: [
                      GestureDetector(
                        onTap: () {
                          // Create show image dialog
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top:9),
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
                focusNode: _educationFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
              SizedBox(height:size.height/35),
              buildInputField2('Email',  (val) {
                setState(() => email = val);
              }),
              SizedBox(height: size.height/35),
              buildInputField2('Password', (val) {
                setState(() => password = val);
              }),
              SizedBox(height: size.height/35),
              buildTextFormField(
                controller: _contactController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                focusNode: _contactFocus,
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
                focusNode: _addressFocus,
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
                labelText: 'Phone Number',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _ocupationFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
