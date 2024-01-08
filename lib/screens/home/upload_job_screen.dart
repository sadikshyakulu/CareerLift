import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:app_jobdirect/screens/widgets/job_list_widget.dart';
import 'package:app_jobdirect/services/global_methods.dart';
import 'package:app_jobdirect/services/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../widgets/bottom_nav_bar.dart';

class UploadJob extends StatefulWidget {
  const UploadJob({Key? key}) : super(key: key);

  @override
  State<UploadJob> createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> {

  // Controllers for various input fields
  TextEditingController _jobCategoryController = TextEditingController(text: "Select the category");
  TextEditingController _jobTitleController = TextEditingController(text: "");
  TextEditingController _jobDescriptionController = TextEditingController(text: "");
  TextEditingController _jobDeadlineController = TextEditingController(text: "Select Job Deadline date");

  // Form key to validate the form
  final _formKey = GlobalKey<FormState>();

  // Variables to manage date and loading state
  DateTime? picked;
  Timestamp? deadlineDateTimeStamp;
  bool _isloading = false;

  @override
  void dispose(){
    super.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDeadlineController.dispose();
    _jobDescriptionController.dispose();
  }

  // Helper method for creating text widgets with a title
  Widget _textTitle({
    required String title
  }) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Text(
        title,
      ),
    );
  }

  // Helper method for creating input field widgets
  Widget _textTile({
    required String valuekey,
    required TextEditingController controller,
    required bool enabled,
    required Function() fct,
    required int maxlength,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          key: Key(valuekey),
          controller: controller,
          enabled: enabled,
          maxLength: maxlength,
          maxLines: valuekey == "Job Description" ? 4 : 1,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$valuekey is required';
            }
            return null;
          },
        ),
      ),
    );
  }

  // Method to handle the job upload task
  void _uploadTask() async {
    // Generate a unique ID for the job
    final jid = const Uuid().v4();
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    // Validate the form
    final isValid = _formKey.currentState!.validate();

    if(isValid){
      // Check if the required fields are selected
      if(_jobDeadlineController.text == "Select Job Deadline date" || _jobCategoryController == "Select the category"){
        GlobalMethods.showErrorDialog(
            error: "Please complete the form",
            ctx: context
        );
        return;
      }
      // Set loading state
      setState(() {
        _isloading =true;
      });
      try{
        // Upload job details to Firestore
        await FirebaseFirestore.instance.collection("Jobs").doc(jid).set({
          'jid': jid,
          'uploadedBy': _uid,
          'email': user.email,
          'jobTitle': _jobTitleController.text,
          'jobDescription': _jobDescriptionController.text,
          'jobDeadline': _jobDeadlineController.text,
          'jobDeadlineTimeStamp': deadlineDateTimeStamp,
          'jobCategory': _jobCategoryController.text,
          'recruitment': true,
          'jobComments':[],
          'createdAt': Timestamp.now(),
          'name': name,
          'address': address,
          'userImage': userImage,
          'applicants': 0,
        });
        // Clear input fields
        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = "Select the category";
          _jobDeadlineController.text = "Select Job Deadline date";
        });
        // Show success message
        await Fluttertoast.showToast(
          msg: 'Task is uploaded',
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.black26,
          fontSize: 24,
        );
      } catch(error){
        // Handle errors and show error dialog
        setState(() {
          _isloading =false;
        });
        GlobalMethods.showErrorDialog(
            error: error.toString(),
            ctx: context
        );
      } finally {
        // Reset loading state
        setState(() {
          _isloading = false;
        });
      }
    }
    else {
      print("It's not valid");
    }
  }

  // Method to display date picker dialog
  void _pickDateDialog() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _jobDeadlineController.text =
        "${pickedDate.year} - ${pickedDate.month} - ${pickedDate.day}";
        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            pickedDate.microsecondsSinceEpoch);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // User is authenticated, continue with your dashboard layout
    return Scaffold(
      bottomNavigationBar: BottomNavbar(indexNum: 1),
      appBar: AppBar(
        title: const Text('Upload jobs'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Card(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10,),
                  const Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Please Fill all the fields",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _textTitle(title: "Job Category"),
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
                                  _jobCategoryController.text = newValue ?? "";
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
                          _textTitle(title: "Job Title: "),
                          _textTile(
                            valuekey: "Job Title",
                            controller: _jobTitleController,
                            enabled: true,
                            fct: () {},
                            maxlength: 100,
                          ),
                          _textTitle(title: "Job Description: "),
                          _textTile(
                            valuekey: "Job Description",
                            controller: _jobDescriptionController,
                            enabled: true,
                            fct: () {},
                            maxlength: 100,
                          ),
                          _textTitle(title: "Job Deadline: "),
                          _textTile(
                            valuekey: "Job Deadline",
                            controller: _jobDeadlineController,
                            enabled: false,
                            fct: () {
                              _pickDateDialog();
                            },
                            maxlength: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: _isloading
                          ? const Loading()
                          : MaterialButton(
                        onPressed: () {
                          _uploadTask();
                        },
                        color: Colors.teal,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Post Now",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
