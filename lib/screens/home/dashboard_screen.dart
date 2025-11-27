// dashboard_screen.dart
import 'package:app_jobdirect/screens/authenticate/toggle_auth.dart';
import 'package:app_jobdirect/screens/home/apply_job.dart';
import 'package:app_jobdirect/screens/home/profile_config_screen.dart';
import 'package:app_jobdirect/screens/home/terms_conditions_screen.dart';
import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:app_jobdirect/screens/widgets/job_list_widget.dart';
import 'package:app_jobdirect/screens/widgets/jobcards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/profile_image_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _jobCategoryFilter;
  String _searchQuery = '';

  late AnimationController _controller;
  late Animation<double> _fade;

  // USER DATA
  String userName = "User";
  String userImageBase64 = "";
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();

    loadUserData(); // ← THIS LOADS REAL USER DATA
  }

  Future<void> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) {
      setState(() {
        userName = "Guest";
        isLoadingUser = false;
      });
      return;
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        setState(() {
          userName = data['name']?.toString().trim().isNotEmpty == true
              ? data['name']
              : user.displayName ?? user.email?.split('@')[0] ?? "User";
          userImageBase64 = data['userImage'] ?? "";
          isLoadingUser = false;
        });
      } else {
        setState(() {
          userName = user.displayName ?? user.email?.split('@')[0] ?? "User";
          isLoadingUser = false;
        });
      }
    } catch (e) {
      print("Load user error: $e");
      setState(() {
        userName = user.displayName ?? user.email?.split('@')[0] ?? "User";
        isLoadingUser = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B4B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Filter by Category",
            style: GoogleFonts.poppins(
                color: const Color(0xFFD946EF), fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: JobListWidget.jobCategoryList.length,
            itemBuilder: (_, i) {
              return ListTile(
                leading:
                    const Icon(Icons.work_outline, color: Color(0xFFD946EF)),
                title: Text(JobListWidget.jobCategoryList[i],
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() =>
                      _jobCategoryFilter = JobListWidget.jobCategoryList[i]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel",
                  style: TextStyle(color: Colors.white70))),
          TextButton(
            onPressed: () {
              setState(() => _jobCategoryFilter = null);
              Navigator.pop(context);
            },
            child: const Text("Clear Filter",
                style: TextStyle(color: Color(0xFFD946EF))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A2C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("CareerLift",
            style: GoogleFonts.jomhuria(fontSize: 48, color: Colors.white)),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white, size: 28),
            onPressed: _showCategoryDialog,
          ),
        ],
      ),

      // DRAWER (unchanged — already perfect)
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E1B4B),
        child: Column(
          children: [
            Container(
              height: 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFFA855F7), Color(0xFF9D4EDD)]),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -60,
                    right: -60,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD946EF).withOpacity(0.25),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80, left: 20),
                    child: Row(
                      children: [
                        // USER PROFILE IMAGE + NAME IN DRAWER HEADER
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFD946EF), width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD946EF).withOpacity(0.6),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: ProfileImageWidget(
                              base64String: userImageBase64,
                              radius: 45,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Welcome back,",
                                style: GoogleFonts.poppins(
                                    color: Colors.white70, fontSize: 13),
                              ),
                              Text(
                                userName,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                children: [
                  _drawerItem(Icons.person_outline_rounded, "My Profile",
                      () async {
                    Navigator.pop(context);
                    final user = _auth.currentUser;
                    if (user == null) return;
                    final doc = await _firestore
                        .collection('users')
                        .doc(user.uid)
                        .get();
                    if (!doc.exists) return;
                    final data = doc.data()!;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProfileConfiguration(
                          name: data['name'] ?? '',
                          contact: data['contact'] ?? '',
                          address: data['address'] ?? '',
                          education: data['education'] ?? '',
                          email: data['email'] ?? user.email ?? '',
                          userImage: data['userImage'] ?? '',
                          userImageUrl: data['userImage'] ?? '',
                          password: '',
                        ),
                      ),
                    );
                  }),
                  _drawerItem(Icons.description_outlined, "Terms & Conditions",
                      () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TermsConditionsPage()));
                  }),
                  const Divider(color: Colors.white24, height: 40),
                  _drawerItem(Icons.logout_rounded, "Logout", () async {
                    await _auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const ToggleAuth()),
                      (route) => false,
                    );
                  }, color: Colors.redAccent),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Version 1.0.0 • Built with love",
                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavbar(indexNum: 0),

      body: FadeTransition(
        opacity: _fade,
        child: Column(
          children: [
            // USER GREETING AT TOP
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  ProfileImageWidget(
                    base64String: userImageBase64,
                    radius: 28,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        userName,
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (val) =>
                    setState(() => _searchQuery = val.toLowerCase()),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search jobs...",
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFFD946EF)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: Color(0xFFD946EF), width: 2)),
                ),
              ),
            ),

            // Hero Image
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF9D4EDD).withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 15)
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child:
                    Image.asset("assets/dashboardhero1.png", fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 7),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Available Jobs",
                      style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  if (_jobCategoryFilter != null)
                    Chip(
                      backgroundColor: const Color(0xFFD946EF),
                      label: Text(_jobCategoryFilter!,
                          style: const TextStyle(color: Colors.white)),
                      onDeleted: () =>
                          setState(() => _jobCategoryFilter = null),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // JOB LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Jobs')
                    .where('recruitment', isEqualTo: true)
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return const Loading();
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text("No jobs available",
                            style: GoogleFonts.poppins(color: Colors.white70)));
                  }

                  var jobs = snapshot.data!.docs;

                  if (_jobCategoryFilter != null) {
                    jobs = jobs
                        .where((j) => j['jobCategory'] == _jobCategoryFilter)
                        .toList();
                  }
                  if (_searchQuery.isNotEmpty) {
                    jobs = jobs
                        .where((j) =>
                            j['jobTitle']
                                .toString()
                                .toLowerCase()
                                .contains(_searchQuery) ||
                            j['jobDescription']
                                .toString()
                                .toLowerCase()
                                .contains(_searchQuery))
                        .toList();
                  }
                  if (jobs.isEmpty) {
                    return Center(
                        child: Text("No matching jobs",
                            style: GoogleFonts.poppins(color: Colors.white70)));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: jobs.length,
                    itemBuilder: (_, i) {
                      var job = jobs[i];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ApplyJob(
                                uploadedBy: job['uploadedBy'],
                                jid: job['jid'],
                              ),
                            ),
                          );
                        },
                        child: JobCards(
                          jobTitle: job['jobTitle'],
                          jobDescription: job['jobDescription'],
                          jid: job['jid'],
                          uploadedBy: job['uploadedBy'],
                          userImage: job['userImage'] ?? '',
                          name: job['name'],
                          address: job['address'],
                          email: job['email'],
                          recruitment: job['recruitment'],
                          jobDeadline: job['jobDeadline'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFFD946EF), size: 28),
      title: Text(
        title,
        style: GoogleFonts.poppins(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onTap: onTap,
    );
  }
}
