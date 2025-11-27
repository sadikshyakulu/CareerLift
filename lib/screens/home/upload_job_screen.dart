import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:app_jobdirect/screens/widgets/job_list_widget.dart';
import 'package:app_jobdirect/services/global_methods.dart';
import 'package:app_jobdirect/services/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import '../widgets/bottom_nav_bar.dart';
import 'dashboard_screen.dart';

class UploadJob extends StatefulWidget {
  const UploadJob({Key? key}) : super(key: key);

  @override
  State<UploadJob> createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _jobTitleController = TextEditingController();
  final _jobDescriptionController = TextEditingController();

  String _selectedCategory = "Select Job Category";
  DateTime? _selectedDeadline;
  Timestamp? _deadlineTimestamp;

  bool _isLoading = false;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF9D4EDD),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1B4B),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF1E1B4B),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
        _deadlineTimestamp = Timestamp.fromDate(picked);
      });
    }
  }

  void _uploadJob() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == "Select Job Category") {
      GlobalMethods.showErrorDialog(
          error: "Please select a job category", ctx: context);
      return;
    }
    if (_selectedDeadline == null) {
      GlobalMethods.showErrorDialog(
          error: "Please select a deadline date", ctx: context);
      return;
    }

    setState(() => _isLoading = true);

    final jobId = const Uuid().v4();
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final userImage = userDoc.exists ? userDoc['userImage'] ?? '' : '';

    try {
      await FirebaseFirestore.instance.collection('Jobs').doc(jobId).set({
        'jid': jobId,
        'uploadedBy': user.uid,
        'email': user.email,
        'jobTitle': _jobTitleController.text.trim(),
        'jobDescription': _jobDescriptionController.text.trim(),
        'jobDeadline':
        "${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}",
        'jobDeadlineTimeStamp': _deadlineTimestamp,
        'jobCategory': _selectedCategory,
        'recruitment': true,
        'jobComments': [],
        'createdAt': Timestamp.now(),
        'name': userDoc['name'] ?? 'Anonymous',
        'address': userDoc['address'] ?? 'Not specified',
        'userImage': userImage,
        'applicants': 0,
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'jobsPosted': FieldValue.increment(1)}, SetOptions(merge: true));

      // SUCCESS TOAST
      Fluttertoast.showToast(
        msg: "Job Posted Successfully!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: const Color(0xFF9D4EDD),
        textColor: Colors.white,
        fontSize: 18,
      );

      // CLEAR FORM
      _jobTitleController.clear();
      _jobDescriptionController.clear();
      setState(() {
        _selectedCategory = "Select Job Category";
        _selectedDeadline = null;
      });

      // THIS IS THE LINE YOU WANTED → GO TO DASHBOARD
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (route) => false,
      );

    } catch (e) {
      GlobalMethods.showErrorDialog(error: "Failed to post job", ctx: context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A2C),
      bottomNavigationBar: BottomNavbar(indexNum: 2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Post a Job",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // GORGEOUS ILLUSTRATION HERE
              Container(
                height: 260,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9D4EDD).withOpacity(0.4),
                      blurRadius: 50,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    "assets/upload_job_illustration.png",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.white.withOpacity(0.1),
                        child: const Icon(Icons.work,
                            size: 100, color: Colors.white70),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Header
              const Text(
                "Post a New Job",
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Text(
                "Share opportunities with the world",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),

              const SizedBox(height: 40),

              // Glassmorphic Form Card
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildDropdown(
                        label: "Job Category",
                        value: _selectedCategory,
                        items: [
                          "Select Job Category",
                          ...JobListWidget.jobCategoryList
                        ],
                        onChanged: (value) =>
                            setState(() => _selectedCategory = value!),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField(
                          controller: _jobTitleController,
                          label: "Job Title",
                          icon: Icons.work_outline,
                          validator: (val) => val!.isEmpty ? "Required" : null),
                      const SizedBox(height: 24),
                      _buildTextField(
                          controller: _jobDescriptionController,
                          label: "Job Description",
                          icon: Icons.description_outlined,
                          maxLines: 5,
                          validator: (val) =>
                              val!.length < 20 ? "Too short" : null),
                      const SizedBox(height: 24),
                      InkWell(
                        onTap: _pickDeadline,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _selectedDeadline == null
                                    ? Colors.white24
                                    : const Color(0xFFD946EF),
                                width: 2),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Color(0xFFD946EF)),
                              const SizedBox(width: 16),
                              Text(
                                _selectedDeadline == null
                                    ? "Select Deadline Date"
                                    : "${_selectedDeadline!.day}/${_selectedDeadline!.month}/${_selectedDeadline!.year}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _uploadJob,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9D4EDD),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            elevation: 15,
                            shadowColor:
                                const Color(0xFF9D4EDD).withOpacity(0.7),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 3))
                              : const Text("Post Job Now",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: const Color(0xFFD946EF)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFD946EF), width: 2)),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF1E1B4B),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon:
            const Icon(Icons.category_outlined, color: Color(0xFFD946EF)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFD946EF), width: 2)),
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (val) => val == "Select Job Category" ? "Required" : null,
    );
  }
}
