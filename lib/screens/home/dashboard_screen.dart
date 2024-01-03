import 'package:app_jobdirect/screens/home/profile_config_screen.dart';
import 'package:app_jobdirect/screens/home/upload_job_screen.dart';
import 'package:app_jobdirect/screens/widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});


  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
final FirebaseAuth _auth = FirebaseAuth.instance;

class _DashboardScreenState extends State<DashboardScreen> {


  @override
  Widget build(BuildContext context) {

    // User is authenticated, continue with your dashboard layout
    return Scaffold(
      backgroundColor: Color(0xFFDADADA),
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
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Search...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top:20,left: 10),
              child: Text("Available Jobs",style:GoogleFonts.poppins(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w600, )),
            ),
          ],
        ),
      ),
      endDrawer: _buildSidebar(context),
    );
  }
}


Widget _buildSidebar(BuildContext context) {
  return Drawer(
    backgroundColor: Color(0xFFDADADA),
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
        SizedBox(height:10),
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
        SizedBox(height:10),
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
        SizedBox(height:10),
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









