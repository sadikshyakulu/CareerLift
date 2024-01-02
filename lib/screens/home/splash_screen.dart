import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

     //Simulate loading process
    Future.delayed(Duration(seconds: 5), () {


      //Navigate to the dashboard after loading
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacementNamed(context, '/wrapper');
      });
    });
  }
  groupMember (String name){
    return Container(
      child: Text(name,
          style:GoogleFonts.jomhuria(color:Colors.white.withOpacity(0.56),fontSize: 34,height: 0.8)),

    );

  }
  AndroidLayout(){
    return Container(
      child:Padding(
        padding: const EdgeInsets.only(top:70),
        child: Column(
          children: [
            groupMember("Sudan Tandukar"),
            groupMember("Justin Shakya"),
            groupMember("Rusar R.Pradhan")

          ],
        ),
      ),

    );

  }
  PCLayout(){
    return Container(
      child:Padding(
        padding: const EdgeInsets.only(top:30),
        child: Column(
          children: [
            groupMember("Sudan Tandukar"),
            groupMember("Justin Shakya"),
            groupMember("Rusar R.Pradhan")

          ],
        ),
      ),

    );
  }
  @override


  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool forAndroid = size.width < 450;

    return Scaffold(
      body: Column(
        children: [
          Container(
              height: 488,
              width: size.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100.0),
                  bottomRight: Radius.circular(100.0),
                ),
                //  can also set other properties of BoxDecoration here if needed
                gradient: LinearGradient(
                  colors: [Color(0xFF429690), Color(0xFF2A7C76)], // list of colors
                  begin: Alignment.topCenter, //  the starting point
                  end: Alignment.bottomCenter, // the ending point
                  stops: [0.0, 0.7], // stops for each color
                  //  can also use 'stops' to define where each color should blend
                  // Stops, if not provided, distribute colors evenly across the gradient.
                ),
              ),
              child: Column(

                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: ClipRect(

                          child: Image.asset(
                            "assets/Group 21.png",
                            fit: BoxFit.cover,
                          ),

                        ),
                      ),

                      Center(
                        child: Padding(
                            padding: const EdgeInsets.only(top:210 ),
                            child: Container(

                              height:242,
                              width:247,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  "assets/logo.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                        ),
                      ),

                    ],
                  ),


                ],
              )
          ),
          SizedBox(
            height:1
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height:350,
                width: size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100.0),
                    topRight: Radius.circular(100.0),
                  ),
                  gradient: LinearGradient(
                    colors: [Color(0xFF2A7C76), Color(0xFF429690)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.7],
                  ),
                ),
                child: Column(
                  children: [
                    Text("JobDirect", style: GoogleFonts.jomhuria(color: Color(0xFF004F5C), fontSize: 96)),
                    Column(
                      children: [
                        forAndroid//if screen width is less then 450 AndriodLayout will be called
                            ? AndroidLayout() // Display mobile layout
                            : PCLayout(), // Display PC layout
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),


    );
  }
}