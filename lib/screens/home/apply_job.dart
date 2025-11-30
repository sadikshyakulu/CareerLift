// apply_job.dart
import 'dart:convert';

import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/widgets/comments_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';
import '../widgets/profile_image_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplyJob extends StatefulWidget {
  final String uploadedBy;
  final String jid;

  const ApplyJob({Key? key, required this.uploadedBy, required this.jid})
      : super(key: key);

  @override
  State<ApplyJob> createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  String? authorName, userImageBase64, jobTitle, jobDescription, jobCategory;
  String? addressCom, emailCom, deadlineDate, postedDate;
  int applicants = 0;
  bool isDeadlineAvailable = false;
  bool _isCommenting = false;
  bool showComments = false;
  String? coverImageBase64;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scale = Tween<double>(begin: 0.9, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
    getJobData();
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> getJobData() async {
    try {
      final jobDoc = await FirebaseFirestore.instance
          .collection('Jobs')
          .doc(widget.jid)
          .get();

      if (!jobDoc.exists) {
        Fluttertoast.showToast(msg: "Job not found");
        if (mounted) Navigator.pop(context);
        return;
      }

      final job = jobDoc.data()! as Map<String, dynamic>;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uploadedBy)
          .get();

      final user = userDoc.exists
          ? userDoc.data()! as Map<String, dynamic>
          : {'name': 'Unknown', 'userImage': ''};

      final Timestamp? deadlineTs = job['jobDeadlineTimeStamp'] as Timestamp?;
      final DateTime deadlineDateTime = deadlineTs?.toDate() ??
          DateTime.now().subtract(const Duration(days: 1));

      final Timestamp createdAt =
          job['createdAt'] as Timestamp? ?? Timestamp.now();

      setState(() {
        authorName = user['name'] ?? 'Unknown User';
        userImageBase64 = user['userImage'] ?? '';
        coverImageBase64 = job['coverImage'] ?? '';
        jobTitle = job['jobTitle'] ?? 'No Title';
        jobDescription = job['jobDescription'] ?? 'No description';
        jobCategory = job['jobCategory'] ?? 'Other';
        addressCom = job['address'] ?? 'No location';
        emailCom = job['email'] ?? 'noemail@example.com';
        applicants = (job['applicants'] ?? 0) as int;
        deadlineDate = job['jobDeadline'] ?? 'Not specified';
        postedDate = createdAt.toDate().toString().split(' ')[0];
        isDeadlineAvailable = DateTime.now().isBefore(deadlineDateTime);
      });
    } catch (e) {
      print("Error loading job: $e");
      if (mounted) {
        Fluttertoast.showToast(
          msg: "Failed to load job details",
          backgroundColor: Colors.red,
        );
      }
    }
  }

  void applyForJob() async {
    if (_auth.currentUser == null) {
      Fluttertoast.showToast(msg: "Please login to apply");
      return;
    }

    final currentUser = _auth.currentUser!;

    // 1. PERFECT EMAIL — NO + SIGNS, PROPER LINE BREAKS
    final subject = Uri.encodeComponent("Application for $jobTitle");
    final bodyText =
        "Dear $authorName,\n\n"
        "I hope you are doing well. I am writing to express my interest in the $jobTitle position. "
        "I believe my skills and experience make me a strong fit for this role, and I would appreciate "
        "the opportunity to discuss how I can contribute to your team.\n\n"
        "Thank you for your time and consideration.\n\n"
        "Best regards,\n"
        "${currentUser.displayName ?? "Applicant User"}";

    String body = Uri.encodeQueryComponent(bodyText);
    body = body.replaceAll("+", "%20");

    final emailUrl = "mailto:$emailCom?subject=$subject&body=$body";

    try {
      await launchUrlString(emailUrl);
    } catch (e) {
      Fluttertoast.showToast(msg: "Could not open email app");
    }

    // 2. REST OF YOUR CODE (applicants, save application, counter)
    await FirebaseFirestore.instance
        .collection('Jobs')
        .doc(widget.jid)
        .update({'applicants': FieldValue.increment(1)});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('applications')
        .doc(widget.jid)
        .set({
      'jobId': widget.jid,
      'jobTitle': jobTitle,
      'companyName': authorName,
      'appliedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .set({
      'applicationsSent': FieldValue.increment(1),
    }, SetOptions(merge: true));

    // Show toast before navigation
    Fluttertoast.showToast(
      msg: "Applied Successfully!",
      backgroundColor: const Color(0xFF9D4EDD),
      textColor: Colors.white,
    );

    // Navigate to home page
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
            (route) => false,
      );
    }
  }


  void postComment() async {
    final commentText = _commentController.text.trim();
    if (commentText.length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Comment too short (min 7 chars)"),
            backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final currentUserId = _auth.currentUser!.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (!userDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("User profile not found"),
              backgroundColor: Colors.red),
        );
        return;
      }

      final userData = userDoc.data()! as Map<String, dynamic>;

      final newComment = {
        'commentId': const Uuid().v4(),
        'commentBody': commentText,
        'userId': currentUserId,
        'name': userData['name'] ?? 'Anonymous',
        'userImageUrl': userData['userImage'] ?? '',
        'time': DateTime.now().toIso8601String(),
      };

      await FirebaseFirestore.instance.collection('Jobs').doc(widget.jid).set({
        'jobComments': FieldValue.arrayUnion([newComment])
      }, SetOptions(merge: true));

      _commentController.clear();
      setState(() {
        _isCommenting = false;
        showComments = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Comment posted successfully!"),
          backgroundColor: Color(0xFF9D4EDD),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      print("Comment Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Display current user's profile image
          if (currentUser != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .get(),
                builder: (context, snapshot) {
                  String currentUserImage = '';
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    currentUserImage = userData['userImage'] ?? '';
                  }

                  return Center(
                    child: ProfileImageWidget(
                      base64String: currentUserImage,
                      radius: 20,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0A2C), Color(0xFF1A0B3E)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fade,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (coverImageBase64 != null && coverImageBase64!.isNotEmpty)
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          base64Decode(coverImageBase64!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // HERO HEADER CARD
                  ScaleTransition(
                    scale: _scale,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFFA855F7), Color(0xFF9D4EDD)]),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF9D4EDD).withOpacity(0.6),
                              blurRadius: 40,
                              spreadRadius: 10),
                        ],
                      ),
                      child: Row(
                        children: [
                          ProfileImageWidget(
                            base64String: userImageBase64,
                            radius: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(jobTitle ?? "Loading...",
                                    style: GoogleFonts.poppins(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                                Text(authorName ?? "Unknown",
                                    style: GoogleFonts.poppins(
                                        fontSize: 18, color: Colors.white70)),
                                Text(addressCom ?? "",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.white60)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // JOB DETAILS CARD
                  _glassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(Icons.work_outline, "Category",
                            jobCategory ?? "N/A"),
                        _infoRow(
                            Icons.people, "Applicants", "$applicants applied"),
                        _infoRow(Icons.calendar_today, "Posted",
                            postedDate ?? "N/A"),
                        _infoRow(
                            Icons.event_busy, "Deadline", deadlineDate ?? "N/A",
                            color: isDeadlineAvailable
                                ? Colors.green
                                : Colors.red),
                        const SizedBox(height: 20),
                        Text("Job Description",
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 10),
                        Text(jobDescription ?? "",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white70,
                                height: 1.6)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // APPLY BUTTON
                  if (isDeadlineAvailable)
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton.icon(
                        onPressed: applyForJob,
                        icon: const Icon(Icons.send, size: 32),
                        label: Text("Apply Now",
                            style: GoogleFonts.poppins(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD946EF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35)),
                          elevation: 20,
                          shadowColor: const Color(0xFFD946EF).withOpacity(0.8),
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text("Application Deadline Passed",
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold))),
                    ),

                  const SizedBox(height: 40),

                  // COMMENTS SECTION
                  _glassCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Comments",
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            IconButton(
                              icon: Icon(
                                  _isCommenting
                                      ? Icons.close
                                      : Icons.add_comment,
                                  color: const Color(0xFFD946EF)),
                              onPressed: () => setState(
                                      () => _isCommenting = !_isCommenting),
                            ),
                          ],
                        ),
                        if (_isCommenting)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _commentController,
                                    maxLines: 3,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Add a comment...",
                                      hintStyle: const TextStyle(
                                          color: Colors.white54),
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.1),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(20),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Icon(Icons.send,
                                      color: Color(0xFFD946EF)),
                                  onPressed: postComment,
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 10),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Jobs')
                              .doc(widget.jid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Text("Error loading comments",
                                  style: TextStyle(color: Colors.red));
                            }
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                      color: Color(0xFFD946EF)));
                            }

                            final data =
                            snapshot.data!.data() as Map<String, dynamic>?;
                            final List comments = data?['jobComments'] ?? [];

                            if (comments.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text("No comments yet. Be the first!",
                                    style: TextStyle(color: Colors.white60)),
                              );
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: comments.length,
                              separatorBuilder: (_, __) => const Divider(
                                  color: Colors.white24, height: 20),
                              itemBuilder: (_, i) {
                                final c = comments[i] as Map<String, dynamic>;
                                return CommentWidget(
                                  commentId: c['commentId'] ?? '',
                                  commenterId: c['userId'] ?? '',
                                  commenterName: c['name'] ?? 'Anonymous',
                                  commentBody: c['commentBody'] ?? '',
                                  commenterImageUrl: c['userImageUrl'] ?? '',
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 10))
        ],
      ),
      child: child,
    );
  }

  Widget _infoRow(IconData icon, String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD946EF), size: 24),
          const SizedBox(width: 12),
          Text("$label: ",
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70)),
          Expanded(
              child: Text(value,
                  style: GoogleFonts.poppins(
                      fontSize: 16, color: color ?? Colors.white))),
        ],
      ),
    );
  }
}