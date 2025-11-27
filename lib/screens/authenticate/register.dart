import 'dart:io';
import 'dart:convert';
import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:app_jobdirect/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:convert';

class Register extends StatefulWidget {
  final VoidCallback? onToggle;  // Add this

  const Register({Key? key, this.onToggle}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? fileImage;
  String? imageBase64;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _contact = TextEditingController();
  final _address = TextEditingController();
  final _education = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300));
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slide = Tween<double>(begin: 80.0, end: 0.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _contact.dispose();
    _address.dispose();
    _education.dispose();
    _controller.dispose();
    super.dispose();
  }

  // ================= IMAGE PICKER =================
  Future pickImage(bool fromCamera) async {
    final picked = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked == null) return;

    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 70,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: const Color(0xFF9D4EDD),
          toolbarWidgetColor: Colors.white,
          backgroundColor: Colors.black,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (cropped != null) {
      setState(() => fileImage = File(cropped.path));
    }
    if (mounted) Navigator.pop(context);
  }

  void showImageDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Choose Photo", style: GoogleFonts.poppins(color: Colors.white)),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Color(0xFFD946EF)),
            title: Text("Camera", style: GoogleFonts.poppins(color: Colors.white)),
            onTap: () => pickImage(true),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: Color(0xFFD946EF)),
            title: Text("Gallery", style: GoogleFonts.poppins(color: Colors.white)),
            onTap: () => pickImage(false),
          ),
        ]),
      ),
    );
  }

  // ================= REGISTER USER =================
  Future registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (fileImage == null) {
      GlobalMethods.showErrorDialog(error: "Please upload a profile photo", ctx: context);
      return;
    }

    setState(() => loading = true);

    try {
      // Create auth user
      await _auth.createUserWithEmailAndPassword(
        email: _email.text.trim().toLowerCase(),
        password: _password.text.trim(),
      );

      final uid = _auth.currentUser!.uid;

      // COMPRESS IMAGE TO ~100KB (SAFE FOR FIRESTORE)
      final bytes = await fileImage!.readAsBytes();
      final compressedImage = await FlutterImageCompress.compressWithList(
        bytes,
        minHeight: 400,
        minWidth: 400,
        quality: 85,
        format: CompressFormat.jpeg,
      );
      if (compressedImage.length > 800 * 1024) { // >800KB
        throw "Image too large. Please choose a smaller photo.";
      }
      // Convert to Base64
      final String imageBase64 = base64Encode(compressedImage);

      // Save to Firestore (users collection)
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "uid": uid,
        "name": _name.text.trim(),
        "email": _email.text.trim().toLowerCase(),
        "contact": _contact.text.trim(),
        "address": _address.text.trim(),
        "education": _education.text.trim(),
        "userImage": imageBase64,                    // ← Base64 string saved!
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Success!
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully!"),
          backgroundColor: Color(0xFF9D4EDD),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      setState(() => loading = false);
      GlobalMethods.showErrorDialog(error: e.toString(), ctx: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A2C),
      body: loading
          ? const Loading()
          : AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slide.value),
            child: Opacity(opacity: _fade.value, child: child),
          );
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 30),

                // Logo
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [Color(0xFFA855F7), Color(0xFF7C3AED)]),
                    boxShadow: [BoxShadow(color: const Color(0xFF9D4EDD).withOpacity(0.6), blurRadius: 50, spreadRadius: 10)],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipOval(child: Image.asset("assets/CareerLiftLogo.png", fit: BoxFit.cover)),
                  ),
                ),

                const SizedBox(height: 30),
                Text("Create Account", style: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white)),
                Text("Join CareerLift today", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70)),

                const SizedBox(height: 40),

                // Glass Card
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withOpacity(0.15)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Profile Photo
                        GestureDetector(
                          onTap: showImageDialog,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: const Color(0xFFD946EF), width: 3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: fileImage == null
                                  ? Container(color: Colors.white.withOpacity(0.1), child: const Icon(Icons.add_a_photo, size: 50, color: Colors.white70))
                                  : Image.file(fileImage!, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        _buildField("Full Name", _name, Icons.person_outline),
                        const SizedBox(height: 18),
                        _buildField("Address", _address, Icons.location_on_outlined),
                        const SizedBox(height: 18),
                        _buildField("Contact Number", _contact, Icons.phone_outlined, TextInputType.phone),
                        const SizedBox(height: 18),
                        _buildField("Education / Major", _education, Icons.school_outlined),
                        const SizedBox(height: 18),
                        _buildField("Email Address", _email, Icons.email_outlined, TextInputType.emailAddress),
                        const SizedBox(height: 18),
                        _buildField("Password", _password, Icons.lock_outline, null, true),

                        const SizedBox(height: 35),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9D4EDD),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 15,
                            ),
                            child: Text("Create Account", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: GoogleFonts.poppins(color: Colors.white70)),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignIn())),
                      child: Text("Sign In", style: GoogleFonts.poppins(color: const Color(0xFFD946EF), fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      String hint,
      TextEditingController controller,
      IconData icon, [
        TextInputType? keyboardType,
        bool isPassword = false,
      ]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      obscureText: isPassword ? obscurePassword : false,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: const Color(0xFFD946EF)),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
        )
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFFD946EF), width: 2)),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return "Please enter $hint";
        if (isPassword && val.length < 6) return "Password must be 6+ characters";
        if (hint.contains("Email") && !val.contains('@')) return "Enter valid email";
        return null;
      },
    );
  }
}