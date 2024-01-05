import 'dart:ui_web';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: size.width * 0.95,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
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
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Scaffold(
            body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
              stream: FirebaseFirestore.instance.
              collection("jobs")
                  .where("jobCategory",isEqualTo: _jobCategoryFilter)
                  .where('recruitment',isEqualTo: true)
                  .orderBy('created',descending: false)
                  .snapshots(),
              builder:(context,AsyncSnapshot snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(),);

                }
                else if (snapshot.connectionState == ConnectionState.active)
                  {
                    if(snapshot.data?.docs.isNotEmpty==true){
                      return ListView.builder(
                        itemCount:  snapshot.data?. docs.Length,
                        itemBuilder: (BuildContext context, int index ){
                          return JobCards(
                            jobTitle: snapshot.data?.docs[index]['Job Title'],
                            jobDescription: snapshot.data?.docs[index]['Job Description'],
                            companyName: snapshot.data?.docs[index]['the company that uploaded'],
                            userImage: snapshot.data?.docs[index]['user image'],
                            recruitment: snapshot.data?.docs[index]['recruitment'],
                            email: snapshot.data?.docs[index]['email'],
                            location: snapshot.data?.docs[index]['location'],
                            jobId: snapshot.data?.docs[index]['joId']



                          );
                        },

                      );

                    }
                  }
              }
            ),
          ),
        ],
      ),
    );

  }
}
