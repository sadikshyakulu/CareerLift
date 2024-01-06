import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/bottom_nav_bar.dart';

class ApplyJob extends StatefulWidget {

  final String uploadedBy;
  final String jid;

  ApplyJob({
    required this.uploadedBy,
    required this.jid,
});

  @override
  State<ApplyJob> createState() => _ApplyJobState();
}

class _ApplyJobState extends State<ApplyJob> {

  String? authorName;
  String? userImageUrl;
  String? jobCategory;
  String? jobDescription;
  String? jobTitle;
  bool? recruitment;
  Timestamp? postedDateTimeStamp;
  Timestamp? deadlineDateTimeStamp;
  String? postedDate;
  String? deadlineDate;
  String? addressCom="";
  String? emailCom="";
  int applicants =0;
  bool isDeadlineAvailable =false;

  void getDataOfJob()async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uploadedBy)
        .get();

    if (userDoc == null) {
      return;
    }
    else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
      });
    }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection("Jobs")
        .doc(widget.jid)
        .get();
    if (jobDatabase == null) {
      return;
    }
    else {
      setState(() {
        jobTitle = jobDatabase.get('jobTitle');
        jobDescription = jobDatabase.get('jobDescription');
        jobCategory = jobDatabase.get('jobCategory');
        addressCom = jobDatabase.get('address');
        emailCom = jobDatabase.get('email');
        applicants = jobDatabase.get('applicants');
        postedDateTimeStamp = jobDatabase.get('createdAt');
        deadlineDateTimeStamp = jobDatabase.get('jobDeadlineTimeStamp');
        deadlineDate = jobDatabase.get('jobDeadline');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';
      }
      );
      var date = deadlineDateTimeStamp!.toDate();
      isDeadlineAvailable =date.isAfter(DateTime.now()) ;
    }
  }





  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFDADADA),
      ),
      child:Scaffold(
        appBar:PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: AppBar(
            backgroundColor: const Color(0xFFDADADA),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20), // Adjust the circular value
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Image.asset(
                    'assets/Group 50.png', // Replace this with the path to your image asset
                    width: 24, // Specify width as per your requirement
                    height: 24, // Specify height as per your requirement
                    // You can also add other properties like fit, alignment, etc. here if needed
                  ),
                  onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const DashboardScreen()));
                  },
                ),
              )
            ),
            title: Text('Apply for Job here',style:GoogleFonts.jomhuria(color:const Color(0xFF004F5C),fontSize: 64)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Padding(
                padding:  const EdgeInsets.only(left:20,),
                child:  Row(
                  children: [
                    Expanded(
                      child: Text(
                          authorName == null
                          ?'hello'
                          :authorName!,
                          maxLines: 3
                          ,style:GoogleFonts.poppins(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w600, )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding:const EdgeInsets.all(8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:10),
                          child: Text(
                            jobTitle==null
                                ?
                                'hello by kljhlkhjlkhl'
                                :
                                jobTitle!,
                            maxLines: 3,
                            style:GoogleFonts.poppins(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold, )
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children:[
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: Colors.grey,
                                  ),
                                  shape: BoxShape.rectangle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      userImageUrl == null
                                          ? Uri.encodeFull("https://i.pinimg.com/564x/57/00/c0/5700c04197ee9a4372a35ef16eb78f4e.jpg")
                                          : userImageUrl!,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )

                            ]
                        )
                      ],
                    ),
                  ),
                ),
                ),

            ],
          ),
        )





      )


    );
  }
}
