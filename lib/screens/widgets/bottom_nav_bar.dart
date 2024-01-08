import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/home/github_jobs_screen.dart';
import 'package:app_jobdirect/screens/home/upload_job_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavbar extends StatelessWidget {
  final int indexNum;

  BottomNavbar({Key? key, required this.indexNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 19, color: Colors.black),
          label: '',
          tooltip: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add, size: 19, color: Colors.black),
          label: '',
          tooltip: 'Add Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.cabin, size: 19, color: Colors.black),
          label: '',
          tooltip: 'GithubJobs',
        ),

      ],
      currentIndex: indexNum,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.black,
      unselectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
      ),
      selectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
      ),

      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UploadJob()),
          );
        }
        if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => GitHubJobsPage()),
          );
        }


      },
    );
  }
}
