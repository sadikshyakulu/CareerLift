import 'package:app_jobdirect/providers/user_provider.dart';
import 'package:app_jobdirect/screens/authenticate/toggle_auth.dart';
import 'package:app_jobdirect/screens/home/profile_config_screen.dart';
import 'package:app_jobdirect/screens/home/terms_conditions_screen.dart';
import 'package:app_jobdirect/screens/widgets/bottom_nav_bar.dart';
import 'package:app_jobdirect/utility/user_utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../shared/loading_animation.dart';
import '../widgets/job_list_widget.dart';
import '../widgets/jobcards.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
final FirebaseAuth _auth = FirebaseAuth.instance;
// User details variables
class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _jobCategoryFilter;
  String _searchQuery = '';
  TextEditingController _jobCategoryController = TextEditingController(text: "Select the category");
  String? userEmail;
  String? userName;
  String? userPassword;
  String? userContact;
  String? userImage;
  String? userEducation;
  String? userAddress;

  // Fetch user details from Firestore

  Future<void> fetchUserDetails() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      // Fetch additional user details from Firestore
      final DocumentSnapshot<Map<String, dynamic>> userDoc =
      await _firestore.collection('Users').doc(user.uid).get();

      print('Fetched user details: $userDoc');

      setState(() {
        userName = userDoc['name'];
        userContact = userDoc['contact'];
        userEmail = userDoc['email'];
        // Check for null or empty values and provide defaults
        userAddress = userDoc['address'] ?? 'Default Address';
        userEducation = userDoc['education'] ?? 'Default Education';
        userPassword = userDoc['password'] ?? 'Default Password';
        userImage = userDoc['userImage'];

        print('Fetched user details: name=$userName, contact=$userContact, address=$userAddress, education=$userEducation, email=$userEmail, password=$userPassword');
      });
    }
  }
  // Update user details in Firestore

  Future<void> updateUserDetails(
      String name,
      String contact,
      String education,
      String address,
      String password,
      ) async {
    final User? user = _auth.currentUser;

    if (user != null) {
      String userId = user.uid;
      await UserUtility.updateDetails(
        _auth,
        _firestore,
        userId,
        name,
        contact,
        education,
        address,
        password,
      );

      // After updating the details, fetch and update the local state if needed
      fetchUserDetails();
    }
  }
  // Sidebar drawer widget

  _buildSidebar(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFDADADA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF429690),
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
                      builder: (_) => ProfileConfiguration(
                        name: userName ?? '',
                        contact: userContact ?? '',
                        address: userAddress ?? '',
                        userImage: userImage ?? '',
                        education: userEducation ?? '',
                        email: userEmail ?? '',
                        password: userPassword ?? '***********',
                        userImageUrl: userImage ?? '',
                      ),
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
                title: const Text('Terms and Conditions'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsConditionsPage()),
                  );
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
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
                              Navigator.of(context).pop(false);
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop(true);
                              // Logout functionality
                              await _auth.signOut();

                              // Navigate to the sign-in page and reset the app state
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ToggleAuth(),
                                ),
                              );
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

  // Display job categories dialog

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
                      _jobCategoryFilter = JobListWidget.jobCategoryList[index];
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
                    _jobCategoryFilter = null;
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

  Widget _buildJobListView(Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> jobs) {
    if (_searchQuery.isNotEmpty) {
      // Convert the Iterable to a List
      final filteredJobs = jobs
          .where((job) =>
      job['jobTitle'].toLowerCase().contains(_searchQuery) ||
          job['jobDescription'].toLowerCase().contains(_searchQuery))
          .toList();

      if (filteredJobs.isEmpty) {
        return const Center(child: Text('No matching jobs'));
      } else {
        return ListView.builder(
          itemCount: filteredJobs.length,
          itemBuilder: (BuildContext context, int index) {
            return JobCards(
              jobTitle: filteredJobs[index]['jobTitle'],
              jobDescription: filteredJobs[index]['jobDescription'],
              jid: filteredJobs[index]['jid'],
              email: filteredJobs[index]['email'],
              name: filteredJobs[index]['name'],
              address: filteredJobs[index]['address'],
              recruitment: filteredJobs[index]['recruitment'],
              uploadedBy: filteredJobs[index]['uploadedBy'],
              userImage: filteredJobs[index]['userImage'],
              jobDeadline: filteredJobs[index]['jobDeadline'],
            );
          },
        );
      }
    } else {
      // No search query, display all jobs
      return ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (BuildContext context, int index) {
          return JobCards(
            jobTitle: jobs.elementAt(index)['jobTitle'],
            jobDescription: jobs.elementAt(index)['jobDescription'],
            jid: jobs.elementAt(index)['jid'],
            email: jobs.elementAt(index)['email'],
            name: jobs.elementAt(index)['name'],
            address: jobs.elementAt(index)['address'],
            recruitment: jobs.elementAt(index)['recruitment'],
            uploadedBy: jobs.elementAt(index)['uploadedBy'],
            userImage: jobs.elementAt(index)['userImage'],
            jobDeadline: jobs.elementAt(index)['jobDeadline'],
          );
        },
      );
    }
  }


  @override
  void initState() {
    super.initState();
    JobListWidget persistentObject = JobListWidget();
    persistentObject.getData();
    fetchUserDetails(); // Fetch user details when the widget initializes
  }

  @override

  Widget build(BuildContext context) {




    var size = MediaQuery.of(context).size;

    return ChangeNotifierProvider(
      create: (context) => UserProvider(), // You may need to replace UserProvider with your actual provider class
      child: Scaffold(
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
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
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

            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Available Jobs",style:GoogleFonts.poppins(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w600, )),
            ),
            const SizedBox(height: 10,),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('Jobs')
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
                      // Apply filter if it is set
                      if (_jobCategoryFilter != null && _jobCategoryFilter!.isNotEmpty) {
                        final filteredJobs = snapshot.data!.docs.where((job) =>
                        job['jobCategory'] == _jobCategoryFilter &&
                            job['recruitment'] == true);

                        if (filteredJobs.isEmpty) {
                          return const Center(child: Text('No jobs for the selected category'));
                        } else {
                          return _buildJobListView(filteredJobs);
                        }
                      } else {
                        // No filter, display all jobs
                        return _buildJobListView(snapshot.data!.docs);
                      }
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


            // Expanded(
            //   child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            //     stream: FirebaseFirestore.instance
            //         .collection('Jobs')
            //         .where('recruitment', isEqualTo: true)
            //         .orderBy('createdAt', descending: false)
            //         .snapshots(),
            //     builder: (context, AsyncSnapshot snapshot) {
            //       if (snapshot.hasError) {
            //         print('Error: ${snapshot.error}');
            //         return Text('Error: ${snapshot.error}');
            //       }
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Loading();
            //       } else if (snapshot.connectionState == ConnectionState.active) {
            //         if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            //           // Apply filter if it is set
            //
            //           if (_jobCategoryFilter != null && _jobCategoryFilter!.isNotEmpty) {
            //             final filteredJobs = snapshot.data!.docs.where((job) =>
            //             job['jobCategory'] == _jobCategoryFilter &&
            //                 job['recruitment'] == true);
            //
            //             if (filteredJobs.isEmpty) {
            //               return const Center(child: Text('No jobs for the selected category'));
            //             } else {
            //               return ListView.builder(
            //                 itemCount: filteredJobs.length,
            //                 itemBuilder: (BuildContext context, int index) {
            //                   return JobCards(
            //                     jobTitle: filteredJobs.elementAt(index)['jobTitle'],
            //                     jobDescription: filteredJobs.elementAt(index)['jobDescription'],
            //                     jid: filteredJobs.elementAt(index)['jid'],
            //                     email: filteredJobs.elementAt(index)['email'],
            //                     name: filteredJobs.elementAt(index)['name'],
            //                     address: filteredJobs.elementAt(index)['address'],
            //                     recruitment: filteredJobs.elementAt(index)['recruitment'],
            //                     uploadedBy: filteredJobs.elementAt(index)['uploadedBy'],
            //                     userImage: filteredJobs.elementAt(index)['userImage'],
            //                     jobDeadline: filteredJobs.elementAt(index)['jobDeadline'],
            //                   );
            //                 },
            //               );
            //             }
            //           } else {
            //             // No filter, display all jobs
            //             return ListView.builder(
            //               itemCount: snapshot.data?.docs.length,
            //               itemBuilder: (BuildContext context, int index) {
            //                 return JobCards(
            //                   jobTitle: snapshot.data!.docs[index]['jobTitle'],
            //                   jobDescription: snapshot.data!.docs[index]['jobDescription'],
            //                   jid: snapshot.data?.docs[index]['jid'],
            //                   email: snapshot.data?.docs[index]['email'],
            //                   name: snapshot.data?.docs[index]['name'],
            //                   address: snapshot.data?.docs[index]['address'],
            //                   recruitment: snapshot.data?.docs[index]['recruitment'],
            //                   uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
            //                   userImage: snapshot.data?.docs[index]['userImage'],
            //                   jobDeadline: snapshot.data?.docs[index]['jobDeadline'],
            //                 );
            //               },
            //             );
            //           }
            //         } else {
            //           return const Center(
            //             child: Text('No jobs'),
            //           );
            //         }
            //       }
            //       return const Center(
            //         child: Text("Found an Error"),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
        endDrawer: _buildSidebar(context),
      ),
    );

  }
}












