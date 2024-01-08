import 'package:app_jobdirect/screens/home/apply_job.dart';
import 'package:app_jobdirect/services/global_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class JobCards extends StatefulWidget {

  final String jobTitle;
  final String jobDescription;
  final String jid ;
  final String userImage;
  final String name;
  final bool recruitment ;
  final String email;
  final String address;
  final String uploadedBy;
  final String jobDeadline;


  const JobCards(
      {
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
      }
      );



  @override
  State<JobCards> createState() => _JobCardsState();
}

class _JobCardsState extends State<JobCards> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteJob() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          content: Container(
            width: 50,
            height: 50,
            alignment: Alignment.center, // Aligns Row at the center vertically
            child: TextButton(
              onPressed: () async{
                try{
                  if(widget.uploadedBy == _uid)
                  {
                    await FirebaseFirestore.instance.collection("Jobs")
                        .doc(widget.jid)
                        .delete();
                    await Fluttertoast.showToast(
                      msg:'Your post"${widget.jobTitle} "has been deleted',
                      toastLength: Toast.LENGTH_LONG,
                      backgroundColor: Colors.grey,
                      fontSize: 20,

                    );
                    Navigator.canPop(context)?Navigator.pop(context):null;

                  }
                  else{
                    GlobalMethods.showErrorDialog(error: "You cannot perform this action",ctx:ctx);
                  }
                }
                catch (error){
                  GlobalMethods.showErrorDialog(error: "This task cannot be deleted",ctx:ctx);
                }
                finally{}

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
        color:Colors.white,
        elevation: 10,
        child: ListTile(
          onTap: (){
            Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>ApplyJob(uploadedBy: widget.uploadedBy, jid: widget.jid,)));
          },
          onLongPress: (){
            _deleteJob();
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          leading: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: const Border(
                  right: BorderSide(width: 2),
                )
            ),
            child: Image.network(widget.userImage),
          ),
          title: Text(
            widget.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,),

          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.jobTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(color:Colors.indigoAccent,fontSize: 20,),

              ),
              const SizedBox(height:5),
              Text(
                widget.jobDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(color:Colors.black,fontSize: 8,fontWeight: FontWeight.bold,),


              ),

            ],
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            size:30,
            color: Colors.black,
          ),

        )

    );
  }
}
