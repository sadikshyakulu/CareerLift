// screens/home/edit_job_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class EditJobScreen extends StatefulWidget {
  final String jobId;
  final Map<String, dynamic> jobData;

  const EditJobScreen({Key? key, required this.jobId, required this.jobData})
      : super(key: key);

  @override
  State<EditJobScreen> createState() => _EditJobScreenState();
}

class _EditJobScreenState extends State<EditJobScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late bool _recruitment;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.jobData['jobTitle']);
    _descController =
        TextEditingController(text: widget.jobData['jobDescription']);
    _recruitment = widget.jobData['recruitment'] ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: BackButton(color: Colors.white),
        title:
            Text("Edit Job", style: GoogleFonts.poppins(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: const Color(0xFF1E1B4B),
                  title: const Text("Delete Job?",
                      style: TextStyle(color: Colors.red)),
                  content: const Text("This cannot be undone."),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete",
                            style: TextStyle(color: Colors.red))),
                  ],
                ),
              );
              if (confirm == true) {
                await FirebaseFirestore.instance
                    .collection('Jobs')
                    .doc(widget.jobId)
                    .delete();
                Fluttertoast.showToast(msg: "Job deleted");
                Navigator.pop(context);
                Navigator.pop(context); // go back to My Jobs
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Job Title",
                labelStyle: const TextStyle(color: Color(0xFFD946EF)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descController,
              maxLines: 6,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Description",
                labelStyle: const TextStyle(color: Color(0xFFD946EF)),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Still Recruiting?",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                const Spacer(),
                Switch(
                    value: _recruitment,
                    onChanged: (v) => setState(() => _recruitment = v),
                    activeColor: const Color(0xFFD946EF)),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('Jobs')
                    .doc(widget.jobId)
                    .update({
                  'jobTitle': _titleController.text.trim(),
                  'jobDescription': _descController.text.trim(),
                  'recruitment': _recruitment,
                });
                Fluttertoast.showToast(
                    msg: "Job updated!",
                    backgroundColor: const Color(0xFF9D4EDD));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD946EF),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: Center(
                child: Text("Save Changes",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
