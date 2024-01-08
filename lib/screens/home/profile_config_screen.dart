import 'dart:io';

import 'package:app_jobdirect/providers/user_provider.dart';
import 'package:app_jobdirect/utility/user_utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// Represents the screen where users can configure their profiles.
class ProfileConfiguration extends StatefulWidget {
  // User data variables
  String name = '';
  String contact = '';
  String address = '';
  String userImage = '';
  String password = '';
  String email = '';
  String education = '';
  final String userImageUrl;

  // Constructor to initialize user data.
  ProfileConfiguration({
    Key? key,
    required this.name,
    required this.address,
    required this.contact,
    required this.userImage,
    required this.password,
    required this.email,
    required this.education,
    required this.userImageUrl,
  }) : super(key: key) {
    print('ProfileConfiguration: name=$name, contact=$contact, address=$address, education=$education, email=$email, password=$password, userImage=$userImage');
  }

  @override
  State<ProfileConfiguration> createState() => _ProfileConfigurationState();
}

class _ProfileConfigurationState extends State<ProfileConfiguration> {
  // Form key for validation and tracking
  final _profileKey = GlobalKey<FormState>();

  // Image file selected by the user
  File? imageFile;

  // Boolean to toggle password visibility
  bool obscurePassword = true;

  // User image URL
  String? userImageUrl;

  // Error message variable
  String err = '';

  // Text editing controllers for each input field
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _educationController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Focus nodes for each input field
  FocusNode _nameFocus = FocusNode();
  FocusNode _contactFocus = FocusNode();
  FocusNode _educationFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with widget values
    _emailController.text = widget.email;
    _nameController.text = widget.name;
    _addressController.text = widget.address;
    _contactController.text = widget.contact;
    _educationController.text = widget.education;
    _passwordController.text = widget.password;
    userImageUrl = widget.userImage;
  }

  // Function to save user profile changes
  void _saveChanges() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userId = auth.currentUser?.uid ?? '';

    String updatedName = _nameController.text;
    String updatedContact = _contactController.text;
    String updatedEducation = _educationController.text;
    String updatedAddress = _addressController.text;
    String updatedPassword = _passwordController.text;

    // Show a toast message indicating profile update
    await Fluttertoast.showToast(
      msg: 'Profile is updated! You will be able to view the changes when you refresh your app',
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.black26,
      fontSize: 24,
    );

    // Update user details in Firestore
    await UserUtility.updateDetails(
      auth,
      firestore,
      userId,
      updatedName,
      updatedContact,
      updatedEducation,
      updatedAddress,
      updatedPassword,
    );

    // Optionally, you can also fetch and update the local state if needed
  }

  // Function to show dialog for choosing image source
  void _showImage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Please choose an option', style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  _getImageFromCamera();
                },
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        Icons.camera_alt_sharp,
                        color: Colors.black,
                      ),
                    ),
                    Text("Camera", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  _getImageFromGallery();
                },
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(7),
                      child: Icon(
                        Icons.image_aspect_ratio_sharp,
                        color: Colors.black,
                      ),
                    ),
                    Text("Gallery", style: GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Function to get image from camera
  void _getImageFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  // Function to get image from gallery
  void _getImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  // Function to crop selected image
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
    UserProvider userProvider = Provider.of<UserProvider>(context);
    var size = MediaQuery.of(context).size;

    // Function to build each text form field
    Widget buildTextFormField({
      required TextEditingController controller,
      required String labelText,
      required bool enable,
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
        enabled: enable,
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

    return Scaffold(
      backgroundColor: const Color(0xFF2D7F79),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D7F79),
        title: Center(child: Text('Edit Profile', style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w600))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // User profile image and image picker
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Form(
                  key: _profileKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          _showImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 9),
                          child: Container(
                            width: size.width * 0.4,
                            height: size.width * 0.4,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.cyanAccent),
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: imageFile == null
                                  ? (widget.userImage.isNotEmpty
                                  ? Image.network(
                                widget.userImage,
                                fit: BoxFit.fill,
                              )
                                  : Image.asset(
                                'assets/editPerson.png',
                                fit: BoxFit.fill,
                              ))
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
              Center(child: Text("Profile picture", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600))),
              SizedBox(height: size.height / 35),
              // Text form fields for user information
              buildTextFormField(
                enable: true,
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
              SizedBox(height: size.height / 35),
              buildTextFormField(
                enable: true,
                controller: _contactController,
                labelText: 'Phone Number',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                focusNode: _contactFocus,
                nextFocusNode: _educationFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height / 35),
              buildTextFormField(
                enable: true,
                controller: _educationController,
                labelText: 'Education',
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                focusNode: _educationFocus,
                nextFocusNode: _addressFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height / 35),
              buildTextFormField(
                enable: true,
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
              SizedBox(height: size.height / 35),
              buildTextFormField(
                enable: false,
                controller: _emailController,
                labelText: 'Email',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                focusNode: _emailFocus,
                nextFocusNode: _passwordFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height / 35),
              buildTextFormField(
                enable: true,
                controller: _passwordController,
                labelText: 'Password',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                focusNode: _passwordFocus,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'This field is missing';
                  }
                  return null;
                },
              ),
              SizedBox(height: size.height / 30),
              // Save button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Call a function to save changes
                    _saveChanges();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
