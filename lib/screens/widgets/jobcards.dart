// widgets/jobcards.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/apply_job.dart';
import 'profile_image_widget.dart';

class JobCards extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String jid;
  final String uploadedBy;
  final String userImage;
  final String name;
  final String address;
  final String email;
  final bool recruitment;
  final String jobDeadline;

  const JobCards({
    Key? key,
    required this.jobTitle,
    required this.jobDescription,
    required this.jid,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.address,
    required this.email,
    required this.recruitment,
    required this.jobDeadline,
  }) : super(key: key);

  @override
  State<JobCards> createState() => _JobCardsState();
}

class _JobCardsState extends State<JobCards> {
  bool isSaved = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  void _checkIfSaved() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final savedJobs = doc['savedJobs'] as List<dynamic>? ?? [];
      setState(() {
        isSaved = savedJobs.contains(widget.jid);
      });
    }
  }

  void _toggleSave() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    final user = FirebaseAuth.instance.currentUser!;
    final ref = FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      if (isSaved) {
        await ref.set({
          'savedJobs': FieldValue.arrayRemove([widget.jid])
        }, SetOptions(merge: true));
        Fluttertoast.showToast(msg: "Removed from saved");
      } else {
        await ref.set({
          'savedJobs': FieldValue.arrayUnion([widget.jid])
        }, SetOptions(merge: true));
        Fluttertoast.showToast(msg: "Job saved!");
      }

      setState(() {
        isSaved = !isSaved;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: Try again", backgroundColor: Colors.red);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isOwner = currentUser?.uid == widget.uploadedBy;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ApplyJob(jid: widget.jid, uploadedBy: widget.uploadedBy),
          ),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF2A1B5E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFD946EF).withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD946EF).withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Profile Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD946EF), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD946EF).withOpacity(0.5),
                        blurRadius: 15,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: ProfileImageWidget(
                      base64String: widget.userImage.isNotEmpty ? widget.userImage : null,
                      radius: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.jobTitle, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      Text(widget.name.isEmpty ? "Anonymous" : widget.name, style: GoogleFonts.poppins(fontSize: 16, color: const Color(0xFFD946EF), fontWeight: FontWeight.w600)),
                      Text(widget.address, style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.recruitment ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.recruitment ? "Open" : "Closed",
                        style: TextStyle(color: widget.recruitment ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (currentUser != null && !isOwner)
                      IconButton(
                        icon: Icon(
                          isSaved ? Icons.bookmark : Icons.bookmark_border,
                          color: isSaved ? const Color(0xFFD946EF) : Colors.white70,
                          size: 28,
                        ),
                        onPressed: isLoading ? null : _toggleSave,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(widget.jobDescription, style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Deadline: ${widget.jobDeadline}", style: GoogleFonts.poppins(fontSize: 13, color: Colors.white60)),
                const Icon(Icons.arrow_forward_ios, color: Color(0xFFD946EF), size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}