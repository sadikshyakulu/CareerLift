// Import necessary packages and screens
import 'package:app_jobdirect/screens/home/dashboard_screen.dart';
import 'package:app_jobdirect/screens/home/upload_job_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget for the custom Bottom Navigation Bar
class BottomNavbar extends StatelessWidget {
  // Current selected index for the Bottom Navigation Bar
  final int indexNum;

  // Constructor with required parameters
  BottomNavbar({Key? key, required this.indexNum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Return a Bottom Navigation Bar with specified items, styles, and functionality
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      items: const [
        // Home Icon and Label
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 25, color: Colors.black),
          label: 'Home',
          tooltip: 'Home',
        ),
        // Add Jobs Icon and Label
        BottomNavigationBarItem(
          icon: Icon(Icons.add, size: 25, color: Colors.black),
          label: 'Add Jobs',
          tooltip: 'Add Jobs',
        ),
      ],
      // Set the current index based on the provided indexNum
      currentIndex: indexNum,
      unselectedItemColor: Colors.black,
      selectedItemColor: Colors.black,
      // Style for unselected label
      unselectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
      ),
      // Style for selected label
      selectedLabelStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
      ),
      // Define onTap function to handle navigation based on selected index
      onTap: (index) {
        // Navigate to DashboardScreen if Home is selected
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
          );
        }
        // Navigate to UploadJob screen if Add Jobs is selected
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UploadJob()),
          );
        }
      },
    );
  }
}
