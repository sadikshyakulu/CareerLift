import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/widgets/comments_widget.dart';
import 'package:app_jobdirect/services/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

import '../../services/global_methods.dart';


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
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;

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
  String? addressCom;
  String? emailCom;
  int applicants =0;
  bool isDeadlineAvailable =false;

  bool showComment =false;

  void getDataOfJob()async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.uploadedBy)
        .get();
    print('uplodedBy in getDataOfJob ${widget.uploadedBy}');

    if (userDoc == null) {
      print("userDoc==null");
      return;
    }
    else {
      setState(() {
        authorName = userDoc.get('name');
        userImageUrl = userDoc.get('userImage');
        print('autherName$authorName');
        print('userImageUrl$userImageUrl');
      });
    }
    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
        .collection("Jobs")
        .doc(widget.jid)
        .get();
    print('jid in getDataOfJob ${widget.uploadedBy}');
    if (!jobDatabase.exists) {
      // Document doesn't exist
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
        recruitment = jobDatabase.get('recruitment');
        var postDate = postedDateTimeStamp!.toDate();
        postedDate = '${postDate.year}-${postDate.month}-${postDate.day}';

        print('Address: $addressCom');
        print('Applicants: $applicants');
        print('Created At: $postedDateTimeStamp');
        print('Email: $emailCom');
        print('joTitle: $jobTitle');
        print('jobDescription: $jobDescription');
        print('jobCategory: $jobCategory');
        print('deadline: $deadlineDateTimeStamp');
        print('jobDeadline: $deadlineDate');
        print('recruitment: $recruitment');
        print('postDate: $postDate');
        print('postedDate: $postedDate');

      }
      );
      var date = deadlineDateTimeStamp!.toDate();
      isDeadlineAvailable =date.isAfter(DateTime.now()) ;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('uploadedBy in initState: ${widget.uploadedBy}');
    getDataOfJob();
  }

  Widget dividerWidget()
  {
    return const Column(
      children: [
        SizedBox( height: 10,),
        Divider(
          thickness: 1,
          color: Colors.black,
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  sendResume(){
    final Uri params =Uri(
        scheme: 'mailto',
        path: emailCom,
        query: 'subject=Applying  for $jobTitle&body=Hello,please attach Resume CV file'
    );
    final url = params.toString();
    launchUrlString(url);
    newApplicant();
  }
  void newApplicant ()async{
    var docRef =FirebaseFirestore .instance
        .collection ('Jobs')
        .doc(widget.jid);
    docRef.update({
      'applicants':applicants+1
    });
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
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
                              ?'Name of the people who Posted'
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
                  color: const Color(0xFFDADADA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              jobTitle==null
                                  ?
                              'Title of Job'
                                  :
                              jobTitle!,
                              maxLines: 3,
                              style:GoogleFonts.poppins(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold, )
                          ),
                        ),
                        const SizedBox(height: 10,),
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
                              ),
                              Padding(
                                padding:const EdgeInsets.only(left:10),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Text(
                                          authorName == null
                                              ?'people who Posted'
                                              :authorName!,
                                          maxLines: 3
                                          ,style:GoogleFonts.inter(color:Colors.black,fontSize: 25,fontWeight: FontWeight.w600, )
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(
                                          addressCom == null
                                              ?'ADDRESS'
                                              :addressCom!,
                                          style:GoogleFonts.inter(color:Colors.black,fontSize: 15, )
                                      ),
                                    ]
                                ),
                              )

                            ]
                        ),
                        dividerWidget(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              applicants.toString(),
                              style:GoogleFonts.inter(color:Colors.black45,fontSize: 20,fontWeight: FontWeight.bold ) ,
                            ),
                            const SizedBox(width: 6,),
                            Text(
                              'Applicants' ,
                              style:GoogleFonts.inter(color:Colors.black45,fontSize: 20,fontWeight: FontWeight.bold ) ,
                            ),
                            const SizedBox( width:10,),
                            const Icon(Icons.how_to_reg,color: Colors.black38,)
                          ],
                        ),
                        FirebaseAuth.instance.currentUser!.uid != widget.uploadedBy
                            ? Container()
                            : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dividerWidget(),
                            Text(
                              'Recruitment',
                              style: GoogleFonts.inter(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    User? user = _auth.currentUser;
                                    final _uid = user!.uid;
                                    if(_uid == widget.uploadedBy)
                                    {
                                      try{
                                        FirebaseFirestore.instance
                                            .collection("Jobs")
                                            .doc(widget.jid)
                                            .update({'recruitment':true});

                                      }catch(error){
                                        GlobalMethods.showErrorDialog(error: "Action cannot be performed ",
                                          ctx: context,
                                        );

                                      }
                                    }
                                    else{
                                      GlobalMethods.showErrorDialog(
                                        error: 'You cannot perform this action ',
                                        ctx: context,
                                      );

                                    }
                                    getDataOfJob();
                                    print(recruitment);


                                  },
                                  child: Text(
                                    'ON',
                                    style: GoogleFonts.inter(color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Opacity(
                                  opacity: recruitment == true ? 1 : 0,
                                  child: const Icon(Icons.check_box_rounded,
                                      color: Colors.green),
                                ),
                                const SizedBox(
                                  width:40,
                                ),
                                TextButton(
                                  onPressed: () {
                                    User? user = _auth.currentUser;
                                    final _uid = user!.uid;
                                    if(_uid == widget.uploadedBy)
                                    {
                                      try{
                                        FirebaseFirestore.instance
                                            .collection("Jobs")
                                            .doc(widget.jid)
                                            .update({'recruitment':false});

                                      }catch(error){
                                        GlobalMethods.showErrorDialog(error: "Action cannot be performed ",
                                          ctx: context,
                                        );

                                      }
                                    }
                                    else{
                                      GlobalMethods.showErrorDialog(
                                        error: 'You cannot perform this action ',
                                        ctx: context,
                                      );

                                    }
                                    getDataOfJob();
                                    print('Recuirement on of button $recruitment');


                                  },
                                  child: Text(
                                    'OFF',
                                    style: GoogleFonts.inter(color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                if (recruitment == false)
                                  const Icon(Icons.check_box_rounded, color: Colors.red),
                                Opacity(
                                  opacity: recruitment == false ? 1 : 0,
                                  child: const Icon(Icons.check_box_rounded,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                        dividerWidget(),
                        Text(
                          "Job Description ",style: GoogleFonts.inter(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height:10),
                        Text(
                          jobDescription == null
                              ? 'hello u are not okay'
                              :jobDescription!,
                          textAlign:TextAlign.justify,
                          style: GoogleFonts.inter(color: Colors.black,
                            fontSize: 15,),

                        ),
                        dividerWidget(),
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                    child:Text(
                                      isDeadlineAvailable
                                          ?
                                      'Actively Recruiting ,Send CV/Resume:'
                                          :
                                      'Deadline Passed away.',
                                      style:GoogleFonts.inter(color:isDeadlineAvailable
                                          ? Colors.green
                                          :Colors.red,
                                        fontSize: 15,),

                                    )
                                ),
                                const SizedBox(height: 6,),
                                Center(
                                  child: MaterialButton(
                                      onPressed: (){
                                        sendResume();
                                      },
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Apply Now',
                                              style:GoogleFonts.inter(color: Colors.black,
                                                fontSize:30 , fontWeight: FontWeight.w600,),
                                            ),
                                            const SizedBox(width: 6,),
                                            const Icon(Icons.folder_shared_outlined),
                                          ],
                                        ),
                                      )
                                  ),
                                ),
                                dividerWidget(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Uploaded on :',style:GoogleFonts.inter(color: Colors.black,
                                      fontSize:15 , fontWeight: FontWeight.w600,)
                                    ),
                                    Text(
                                      postedDate==null
                                          ?'Date'
                                          :postedDate!,
                                      style:GoogleFonts.inter(color: Colors.blueAccent,
                                        fontSize:15 , fontWeight: FontWeight.w600,) ,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 12,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Deadline date :',style:GoogleFonts.inter(color: Colors.black,
                                      fontSize:15 , fontWeight: FontWeight.w600,)
                                    ),
                                    Text(
                                      deadlineDate==null
                                          ?'Date'
                                          :deadlineDate!,
                                      style:GoogleFonts.inter(color: const Color(0xFFEB4335),
                                        fontSize:15 , fontWeight: FontWeight.w600,) ,
                                    ),
                                  ],
                                ),
                                dividerWidget(),
                              ],
                            )
                        ),
                        Padding(
                          padding:const EdgeInsets.all(4.0),
                          child: Card(
                              color: const Color(0xFFDADADA),
                              child:Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AnimatedSwitcher(
                                      duration:const Duration(
                                        milliseconds: 500,
                                      ),
                                      child: _isCommenting
                                          ?
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex:3,
                                            child: TextField(
                                              controller: _commentController,
                                              style: GoogleFonts.inter(color: Colors.black,
                                                fontSize:15 , fontWeight: FontWeight.w600,),
                                              maxLength: 200,
                                              keyboardType: TextInputType.text,
                                              maxLines:6,
                                              decoration: InputDecoration(
                                                  filled:true,
                                                  fillColor: Theme.of(context).scaffoldBackgroundColor,
                                                  enabledBorder:const UnderlineInputBorder(
                                                    borderSide:BorderSide(color: Colors.black),

                                                  ),
                                                  focusedBorder: const OutlineInputBorder(
                                                    borderSide: BorderSide(color:Colors.pink),

                                                  )

                                              ),

                                            ),
                                          ),
                                          Flexible(
                                              child: Column(
                                                  children:[
                                                    Padding(
                                                        padding:  const EdgeInsets.symmetric(horizontal: 8),
                                                        child:MaterialButton(
                                                          onPressed: ()async{
                                                            if (_commentController.text.length<7){

                                                              GlobalMethods.showErrorDialog(
                                                                error: 'Comment cannot be less than 7 characters',
                                                                ctx:context,
                                                              );
                                                            }
                                                            else{
                                                              final _generatedId =const Uuid().v4();
                                                              await FirebaseFirestore.instance.collection('Jobs')
                                                                  .doc(widget.jid)
                                                                  .update({
                                                                'jobComments':
                                                                FieldValue.arrayUnion([{
                                                                  'userId':FirebaseAuth.instance.currentUser!.uid,
                                                                  'commentId':_generatedId,
                                                                  'name':name,
                                                                  'userImageUrl':userImage,
                                                                  'commentBody':_commentController.text,
                                                                  'time':Timestamp.now(),
                                                                }]),
                                                              });
                                                              await Fluttertoast.showToast(
                                                                  msg:'Your comment has been added',
                                                                  toastLength:Toast.LENGTH_LONG,
                                                                  backgroundColor: Colors.grey,
                                                                  fontSize: 18.0
                                                              );
                                                              _commentController.clear();
                                                            }
                                                            setState(() {
                                                              showComment=true;
                                                            });
                                                          },
                                                          color: Colors.blueAccent,
                                                          elevation:  0,
                                                          shape:RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            'Post',style:GoogleFonts.inter(color: const Color(0xFFEB4335),
                                                            fontSize:15 , fontWeight: FontWeight.w600,) ,
                                                          ),
                                                        )
                                                    ),
                                                    TextButton(
                                                      onPressed: (){
                                                        setState(() {
                                                          _isCommenting= !_isCommenting;
                                                          showComment=false;
                                                        });
                                                      },
                                                      child:Text('Cancel',style:GoogleFonts.inter(color: const Color(0xFFEB4335),
                                                        fontSize:15 , fontWeight: FontWeight.w600,) ,),
                                                    )
                                                  ]
                                              )
                                          ),

                                        ],
                                      )
                                          :
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: (){
                                              setState(() {
                                                _isCommenting= !_isCommenting;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.add_comment_rounded,
                                              color: Colors.blueAccent,
                                              size: 40,
                                            ),
                                          ),
                                          const SizedBox(width: 10 ),
                                          IconButton(
                                            onPressed: (){
                                              setState(() {
                                                showComment=true;
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.arrow_drop_down_circle,
                                              color: Colors.blueAccent,
                                              size: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    showComment == false
                                        ? Container()
                                        :
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: FutureBuilder<DocumentSnapshot>(
                                        future:FirebaseFirestore.instance
                                            .collection('Jobs')
                                            .doc(widget.jid)
                                            .get(),
                                        builder: (context,snapshot){
                                          if(snapshot.connectionState==ConnectionState.waiting)
                                          {
                                            return const Center(child:CircularProgressIndicator(),);

                                          }
                                          else{
                                            if(snapshot.data==null){
                                              const Center (
                                                child:Text('No Comment for this job'),
                                              );
                                            }
                                          }
                                          return ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context,index){
                                              return CommentWidget(
                                                commentId:snapshot.data!['jobComments'][index]['commentId'],
                                                commenterId:snapshot.data!['jobComments'][index]['userId'],
                                                commenterName: snapshot.data!['jobComments'][index]['name'],
                                                commentBody: snapshot.data!['jobComments'][index]['commentBody'],
                                                commenterImageUrl: snapshot.data!['jobComments'][index]['userImageUrl'],
                                              );
                                            },
                                            separatorBuilder: (context,index){
                                              return const Divider(
                                                thickness: 1,
                                                color: Colors.grey,

                                              );
                                            },
                                            itemCount: snapshot.data!['jobComments'].length,

                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }
}
