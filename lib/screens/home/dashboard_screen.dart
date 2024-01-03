import 'package:app_jobdirect/screens/home/upload_job_screen.dart';
import 'package:app_jobdirect/screens/widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

    final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    // User is authenticated, continue with your dashboard layout
    return Scaffold(
      bottomNavigationBar: BottomNavbar(indexNum: 0),
      appBar: AppBar(
        title: const Text('Job Finder Dashboard'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Padding(
            padding:  EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: Container(),
      drawer: _buildSidebar(context),
    );
  }
}


  Widget _buildSidebar(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child:  Text("Job Direct"),
          ),
          ListTile(
            title: const Text('Profile Configuration'),
            onTap: () {
              // Close the sidebar
              Navigator.pop(context);
              // Navigate to the profile configuration page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UploadJob(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Upload Jobs'),
            onTap: () {
              // Close the sidebar
              Navigator.pop(context);
              // Add logic to navigate to the job configuration page if needed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UploadJob(),
                ),
              );

            },
          ),
          ListTile(
            title: const Text('Applied Jobs'),
            onTap: () async {
              // Close the sidebar
              Navigator.pop(context);

            },
          ),

        ],
      ),
    );
  }








