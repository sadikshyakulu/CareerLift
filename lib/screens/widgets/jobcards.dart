import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobCards extends StatefulWidget {

  final String jobTitle;
  final String jobDescription;
  final String jobCategory ;
  final String userImage;
  final String companyName;
  final String recruitment ;
  final String email;
  final String location;

  const JobCards(
      {
        super.key,

        required this.jobTitle,
        required this.jobDescription,
        required this.jobCategory,
        required this.userImage,
        required this.companyName,
        required this.recruitment,
        required this.email,
        required this.location});



  @override
  State<JobCards> createState() => _JobCardsState();
}

class _JobCardsState extends State<JobCards> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color:Colors.white,
      elevation: 10,
      child: ListTile(
        onTap: (){},
        onLongPress: (){},
        contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: const Border(
              right: BorderSide(width: 2),
            )
          ),
          child: Image.network(widget.userImage),
        ),
        title: Text(
          widget.companyName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,),

        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.jobTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(color:Colors.black,fontSize: 20,fontWeight: FontWeight.bold,),


            ),

          ],
        ),

      )

    );
  }
}
