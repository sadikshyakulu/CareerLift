// profile_config_screen.dart
import 'dart:io';
import 'package:app_jobdirect/utility/user_utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../utility/image_helper.dart';
import '../widgets/profile_image_widget.dart';

class ProfileConfiguration extends StatefulWidget {
  final String name,
      contact,
      address,
      userImage,
      password,
      email,
      education,
      userImageUrl;

  const ProfileConfiguration({
    Key? key,
    required this.name,
    required this.contact,
    required this.address,
    required this.userImage,
    required this.password,
    required this.email,
    required this.education,
    required this.userImageUrl,
  }) : super(key: key);

  @override
  State<ProfileConfiguration> createState() => _ProfileConfigurationState();
}

class _ProfileConfigurationState extends State<ProfileConfiguration>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  File? imageFile;
  late AnimationController _controller;
  late Animation<double> _fade;

  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _educationController;
  late TextEditingController _addressController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();

    _nameController = TextEditingController(text: widget.name);
    _contactController = TextEditingController(text: widget.contact);
    _educationController = TextEditingController(text: widget.education);
    _addressController = TextEditingController(text: widget.address);
    _passwordController = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _educationController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (pickedFile != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Image",
            toolbarColor: const Color(0xFF9D4EDD),
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.black,
            cropFrameColor: const Color(0xFFD946EF),
            cropGridColor: Colors.white24,
            activeControlsWidgetColor: const Color(0xFFD946EF),
          ),
          IOSUiSettings(title: "Crop Image"),
        ],
      );

      if (cropped != null) {
        setState(() => imageFile = File(cropped.path));
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(msg: "User not logged in");
      return;
    }

    try {
      String? newImageUrl;

      // Upload image if user selected a new one
      if (imageFile != null) {
        newImageUrl =
            await UserUtility.uploadProfileImage(imageFile!, user.uid);
      }

      // Update profile in Firestore
      await UserUtility.updateDetails(
        FirebaseAuth.instance,
        FirebaseFirestore.instance,
        user.uid,
        _nameController.text.trim(),
        _contactController.text.trim(),
        _educationController.text.trim(),
        _addressController.text.trim(),
        _passwordController.text,
        profileImageUrl: newImageUrl, // This will save the new image URL
      );

      // Success!
      Fluttertoast.showToast(
        msg: "Profile Updated Successfully!",
        backgroundColor: const Color(0xFF9D4EDD),
        textColor: Colors.white,
        fontSize: 18,
        gravity: ToastGravity.CENTER,
      );

      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update profile",
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// --- USER IMAGE (same style as MyProfileScreen)
            GestureDetector(
              onTap: _pickAndCropImage,
              child: Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD946EF).withOpacity(0.4),
                          blurRadius: 25,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: imageFile != null
                          ? Image.file(imageFile!, fit: BoxFit.cover)
                          : ProfileImageWidget(
                              base64String: widget.userImage,
                              radius: 140,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Tap to change photo",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            /// --- FORM CARD
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField("Full Name", _nameController, Icons.person),
                    const SizedBox(height: 18),
                    _buildField("Phone Number", _contactController, Icons.phone,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 18),
                    _buildField("Education / Degree", _educationController,
                        Icons.school),
                    const SizedBox(height: 18),
                    _buildField("Address / City", _addressController,
                        Icons.location_on),
                    const SizedBox(height: 18),
                    _buildField("Email",
                        TextEditingController(text: widget.email), Icons.email,
                        enabled: false),
                    const SizedBox(height: 18),
                    _buildField("New Password (optional)", _passwordController,
                        Icons.lock,
                        isPassword: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 35),

            /// --- SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD946EF),
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPassword = false,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: const Color(0xFFD946EF)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFD946EF), width: 2),
        ),
      ),
      validator: (val) => val!.trim().isEmpty ? "Required" : null,
    );
  }
}
Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
      bool enabled = true,
      bool isPassword = false,
      TextInputType keyboardType = TextInputType.text,
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        enabled: enabled,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFFD946EF)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFD946EF), width: 2),
          ),
        ),
        validator: (v) => v!.trim().isEmpty ? "Required" : null,
      ),
    ],
  );
}
