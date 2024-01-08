import 'package:app_jobdirect/screens/home/apply_job.dart';
import 'package:app_jobdirect/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

// JobCards class represents a card widget for displaying job information.
class JobCards extends StatefulWidget {
  // Properties representing job details.
  final String jobTitle;
  final String jobDescription;
  final String jid;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String address;
  final String uploadedBy;
  final String jobDeadline;

  // Constructor for initializing JobCards with required properties.
  const JobCards({
    required this.jobTitle,
    required this.jobDescription,
    required this.userImage,
    required this.recruitment,
    required this.email,
    required this.address,
    required this.uploadedBy,
    required this.jid,
    required this.name,
    required this.jobDeadline,
  });

  @override
  State<JobCards> createState() => _JobCardsState();
}

class _JobCardsState extends State<JobCards> {
  // Firebase authentication instance.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to delete a job.
  _deleteJob() {
    // Retrieve the current user.
    User? user = _auth.currentUser;
    final _uid = user!.uid;

    // Show a confirmation dialog for deleting the job.
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () async {
                try {
                  // Check if the current user uploaded the job.
                  if (widget.uploadedBy == _uid) {
                    // Delete the job from Firestore.
                    await FirebaseFirestore.instance
                        .collection("Jobs")
                        .doc(widget.jid)
                        .delete();

                    // Show a success toast.
                    await Fluttertoast.showToast(
                      msg:
                      'Your post "${widget.jobTitle}" has been deleted',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey,
                      fontSize: 20,
                    );

                    // Close the dialog and pop the current screen.
                    Navigator.canPop(context)
                        ? Navigator.pop(context)
                        : null;
                  } else {
                    // Show an error dialog if the current user is not the uploader.
                    GlobalMethods.showErrorDialog(
                      error: "You cannot perform this action",
                      ctx: ctx,
                    );
                  }
                } catch (error) {
                  // Show an error dialog for any unexpected error.
                  GlobalMethods.showErrorDialog(
                    error: "This task cannot be deleted",
                    ctx: ctx,
                  );
                } finally {}
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete_rounded, color: Colors.black),
                    Text(
                      "Delete",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      child: ListTile(
        // Navigate to the ApplyJob screen when the card is tapped.
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ApplyJob(
                uploadedBy: widget.uploadedBy,
                jid: widget.jid,
              ),
            ),
          );
        },
        // Display delete confirmation dialog on long press.
        onLongPress: () {
          _deleteJob();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        leading: Container(
          // Display the user image in a rounded container.
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              right: BorderSide(width: 2),
            ),
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          // Display the job poster's name with styling.
          widget.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              // Display the job title with styling.
              widget.jobTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.indigoAccent,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              // Display the job description with styling.
              widget.jobDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
