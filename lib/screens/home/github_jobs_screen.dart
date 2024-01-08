import 'package:app_jobdirect/screens/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<List<Map<String, dynamic>>> fetchJobs() async {
  final response = await http.get(Uri.parse('https://jobs.github.com/positions.json'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data);
  } else {
    throw Exception('Failed to load jobs');
  }
}

class GitHubJobsPage extends StatefulWidget {
  @override
  _GitHubJobsPageState createState() => _GitHubJobsPageState();
}

class _GitHubJobsPageState extends State<GitHubJobsPage> {
  late Future<List<Map<String, dynamic>>> _jobs;

  @override
  void initState() {
    super.initState();
    _jobs = fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavbar(indexNum: 2),
      appBar: AppBar(
        title: Text('GitHub Jobs'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _jobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No jobs found');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final job = snapshot.data![index];
                return ListTile(
                  title: Text(job['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job['company']),
                      SizedBox(height: 4),
                      Text('URL: ${job['url']}'), // Display the job URL
                    ],
                  ),
                  // Add more details as needed
                  onTap: () async {
                    final jobUrl = job['url'];
                    if (await canLaunch(jobUrl)) {
                      await launch(jobUrl);
                    } else {
                      print('Could not launch $jobUrl');
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
