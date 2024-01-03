import 'package:app_jobdirect/screens/home/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavbar extends StatelessWidget{

  int indexNum=0;
  BottomNavbar({super.key, required this.indexNum});

  @ override
  Widget build (BuildContext context){
    return BottomNavigationBar(
      backgroundColor:Colors.white,

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size:19 ,color: Colors.black,),
          label: 'Home',
        ),

        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add Jobs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Bookmarked',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: indexNum,
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      selectedItemColor: Colors.black,
      selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),// Color of unselected items// Set the current index of the selected item
      onTap: (index) {
        if(index==0){
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (_)=> const DashboardScreen()));
        }

      },

    );

  }

}