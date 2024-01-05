import 'package:flutter/material.dart';

class JobTile extends StatelessWidget {


  // const JobTile({Key? key, required this.jobsList, required this.onTileTap}) : super(key: key);
  //
  // final JobModel jobsList;
  // final VoidCallback onTileTap;

  @override
  Widget build(BuildContext context) {
    return const InkWell(
      // onTap: onTileTap,
      child: Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.teal,
            ),
            // title: Text(jobsList.name),
            // subtitle: Text('Job details: ${jobsList.qualification}, ${jobsList.salary}'),
          ),
        ),
      ),
    );
  }
}

