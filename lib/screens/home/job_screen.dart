import 'dart:ui_web';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared/loading_animation.dart';
import '../widgets/job_list_widget.dart';
import '../widgets/jobcards.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  String? _jobCategoryFilter;

  TextEditingController _jobCategoryController = TextEditingController(text: "Select the category");

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
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
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('Jobs')
                .where('jobCategory', isEqualTo: _jobCategoryFilter)
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
    );

  }
}
