import 'package:app_jobdirect/screens/home/job_screen.dart';
import 'package:app_jobdirect/screens/home/profile_config_screen.dart';
import 'package:app_jobdirect/screens/home/upload_job_screen.dart';
import 'package:app_jobdirect/screens/widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared/loading_animation.dart';
import '../widgets/job_list_widget.dart';
import '../widgets/jobcards.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});


  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
final FirebaseAuth _auth = FirebaseAuth.instance;

class _DashboardScreenState extends State<DashboardScreen> {
  String? _jobCategoryFilter;
  TextEditingController _jobCategoryController = TextEditingController(text: "Select the category");
  String? jobCategoryFilter;


  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.black54,
          title: Text(
            "Job Category",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.teal,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
          content: Container(
            width: size.width * 0.9,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: JobListWidget.jobCategoryList.length,
              itemBuilder: (ctx, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      jobCategoryFilter = JobListWidget.jobCategoryList[index];
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    print(
                        "job category, ${JobListWidget.jobCategoryList[index]}"
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.green,
                        ),
                        Text(
                          JobListWidget.jobCategoryList[index],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                      color: Colors.red[200]
                  ),
                )
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    jobCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  'Cancel filter',
                  style: TextStyle(
                      color: Colors.red[200]
                  ),
                )
            )
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // User is authenticated, continue with your dashboard layout
    return Scaffold(
      backgroundColor: const Color(0xFFDADADA),
      bottomNavigationBar: BottomNavbar(indexNum: 0),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: AppBar(
          backgroundColor: const Color(0xFF2C7F79),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // Adjust the circular value
            ),
          ),
          title: Text('Job Direct',style:GoogleFonts.jomhuria(color:const Color(0xFF004F5C),fontSize: 64)),
          leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: ClipRect(

              child: Image.asset(
                "assets/small logo.png",
                width: 50,
                height: 50,
              ),

            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Padding(
              padding:  const EdgeInsets.all(8.0),
              child:  Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search...',
                        prefix: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Adjust the space between TextField and icon
                  IconButton(
                      onPressed: (){
                        _showTaskCategoriesDialog(size: size);
                      },
                      icon: Icon(Icons.sort)
                  ) // Replace "other_icon" with the desired icon
                ],
              ),
            ),
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: size.width * 0.95,
            child: DropdownButtonFormField<String>(
              decoration:  InputDecoration(
                filled: true,
                fillColor: Color(0xFF2C7F79),
                border: OutlineInputBorder(),
              ),
              dropdownColor: Colors.black54,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white, // Change the dropdown arrow color here
              ),
              value: _jobCategoryController.text.isNotEmpty
                  ? JobListWidget.jobCategoryList.contains(_jobCategoryController.text)
                  ? _jobCategoryController.text
                  : null
                  : null,
              onChanged: (String? newValue) {
                setState(() {
                  _jobCategoryFilter = newValue ?? "";
                });
              },
              items: JobListWidget.jobCategoryList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style:GoogleFonts.poppins(color:Colors.white,fontSize: 12,fontWeight: FontWeight.w600, )),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text("Available Jobs",style:GoogleFonts.poppins(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w600, )),
          ),
          const SizedBox(height: 10,),
          // JobCards(
          //   userImage:  "assets/small logo.png",
          //   name: "Sudan",
          //   jobDescription: "hello",
          //   jobTitle: "hehe",
          //   jid: "2",
          //   uploadedBy: "sudan",
          //   email: "hero",
          //   address: "sanepa",
          //   recruitment: true,
          // )
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Jobs')
                  .where('jobCategory', isEqualTo: jobCategoryFilter)
                  .where('recruitment', isEqualTo: true)
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loading();
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return JobCards(
                          jobTitle: snapshot.data!.docs[index]['jobTitle'],
                          jobDescription: snapshot.data!.docs[index]['jobDescription'],
                          jid: snapshot.data?.docs[index]['jid'],
                          email: snapshot.data?.docs[index]['email'],
                          name: snapshot.data?.docs[index]['name'],
                          address: snapshot.data?.docs[index]['address'],
                          recruitment: snapshot.data?.docs[index]['recruitment'],
                          uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                          userImage: snapshot.data?.docs[index]['userImage'],
                          jobDeadline: snapshot.data?.docs[index]['jobDeadline'],
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No jobs'),
                    );
                  }
                }
                return const Center(
                  child: Text("Found an Error"),
                );
              },
            ),
          ),
        ],
      ),
      endDrawer: _buildSidebar(context),
    );
  }
}


Widget _buildSidebar(BuildContext context) {
  return Drawer(
    backgroundColor: const Color(0xFFDADADA),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
         DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: Row(
            children: [
              Text("Job Direct",style:GoogleFonts.jomhuria(color:const Color(0xFF004F5C),fontSize: 64)),
            ],
          ),
        ),
        const SizedBox(height:10),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color
              borderRadius: BorderRadius.circular(10.0), // Set circular border radius
            ),
            child: ListTile(
              title: const Text('Profile Configuration'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileConfiguration(),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height:10),
        Padding(
          padding: const EdgeInsets.only(left:5),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color
              borderRadius: BorderRadius.circular(10.0), // Set circular border radius
            ),
            child: ListTile(
              title: const Text('Upload Jobs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadJob(),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height:10),
        Padding(
          padding: const EdgeInsets.only(left:5),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color
              borderRadius: BorderRadius.circular(10.0), // Set circular border radius
            ),
            child: ListTile(
              title: const Text('Applied Jobs'),
              onTap: () {
                Navigator.pop(context);
                // Add logic for handling Applied Jobs screen navigation
              },
            ),
          ),
        ),
        const SizedBox(height: 20), // Add space between the list items and the Logout button
        const Divider(
          thickness: 2,
        ), // Add a divider for separation

        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: BoxDecoration(
              color: Colors.white, // Set the background color
              borderRadius: BorderRadius.circular(10.0), // Set circular border radius
            ),
            child: ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () async {
                // Show the confirmation dialog
                bool logoutConfirmed = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // Return false if user selects 'No'
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); // Return true if user selects 'Yes'
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                );

                // Check the response and logout if confirmed
                if (logoutConfirmed == true) {
                  // Logout functionality
                  await _auth.signOut();
                }
              },
            ),
          ),
        ),



      ],
    ),
  );
}









