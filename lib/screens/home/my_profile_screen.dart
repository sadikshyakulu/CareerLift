// screens/home/my_profile_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile_image_widget.dart';
import '../widgets/jobcards.dart';
import 'apply_job.dart';
import 'edit_job_screen.dart'; // ← Make sure this exists

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);
  @override State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A2C),
      bottomNavigationBar: const BottomNavbar(indexNum: 3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("My Profile",
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // PROFILE HEADER
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox(height: 150);
              }
              final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};

              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ProfileImageWidget(
                        base64String: data['userImage'] ?? '', radius: 60),
                    const SizedBox(height: 16),
                    Text(data['name'] ?? 'User',
                        style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(user.email ?? '',
                        style: GoogleFonts.poppins(color: Colors.white60)),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statCard("Posted", data['jobsPosted'] ?? 0),
                        _statCard("Applied", data['applicationsSent'] ?? 0),
                        _statCard("Saved",
                            (data['savedJobs'] as List<dynamic>?)?.length ?? 0),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          // TABS
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFD946EF),
            unselectedLabelColor: Colors.white60,
            indicatorColor: const Color(0xFFD946EF),
            tabs: const [
              Tab(text: "My Jobs"),
              Tab(text: "Applied"),
              Tab(text: "Saved"),
            ],
          ),

          // TAB VIEWS
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _myJobsTab(),
                _appliedJobsTab(),
                _savedJobsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, int count) {
    return Column(
      children: [
        Text(count.toString(),
            style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFD946EF))),
        Text(label, style: GoogleFonts.poppins(color: Colors.white70)),
      ],
    );
  }

  Widget _myJobsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Jobs')
          .where('uploadedBy', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _emptyState("No jobs posted yet", Icons.work_off);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, i) {
            var job = snapshot.data!.docs[i];
            var jobData = job.data() as Map<String, dynamic>;

            return Card(
              color: const Color(0xFF1E1B4B),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: ProfileImageWidget(base64String: jobData['userImage'] ?? '', radius: 25),
                title: Text(jobData['jobTitle'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text("Tap to edit or delete", style: TextStyle(color: Colors.white60)),
                trailing: Icon(Icons.edit, color: Color(0xFFD946EF)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditJobScreen(jobId: job.id, jobData: jobData),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _appliedJobsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('applications')
          .orderBy('appliedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _emptyState("No applications yet", Icons.send);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, i) {
            var app = snapshot.data!.docs[i];
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Jobs')
                  .doc(app['jobId'])
                  .get(),
              builder: (context, jobSnap) {
                if (!jobSnap.hasData || !jobSnap.data!.exists) {
                  return const SizedBox();
                }
                var job = jobSnap.data!;
                return JobCards(
                  jobTitle: job['jobTitle'],
                  jobDescription: job['jobDescription'],
                  jid: job.id,
                  uploadedBy: job['uploadedBy'],
                  userImage: job['userImage'] ?? '',
                  name: job['name'],
                  address: job['address'],
                  email: job['email'],
                  recruitment: job['recruitment'],
                  jobDeadline: job['jobDeadline'],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _savedJobsTab() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final saved = (snapshot.data!.data() as Map?)?['savedJobs'] as List<dynamic>? ?? [];
        if (saved.isEmpty) return _emptyState("No saved jobs", Icons.bookmark_border);

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: saved.length,
          itemBuilder: (context, i) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('Jobs').doc(saved[i].toString()).get(),
              builder: (context, jobSnap) {
                if (!jobSnap.hasData || !jobSnap.data!.exists) return const SizedBox();
                var job = jobSnap.data!;
                return JobCards(
                  jobTitle: job['jobTitle'],
                  jobDescription: job['jobDescription'],
                  jid: job.id,
                  uploadedBy: job['uploadedBy'],
                  userImage: job['userImage'] ?? '',
                  name: job['name'],
                  address: job['address'],
                  email: job['email'],
                  recruitment: job['recruitment'],
                  jobDeadline: job['jobDeadline'],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _emptyState(String text, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.white30),
          const SizedBox(height: 20),
          Text(text,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white60)),
        ],
      ),
    );
  }
}