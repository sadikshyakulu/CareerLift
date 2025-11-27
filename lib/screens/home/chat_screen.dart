import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../home/dashboard_screen.dart';

class ChatScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const ChatScreen({super.key, this.onBackPressed});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0A2C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1B4B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          },
        ),
        title: Row(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
              builder: (context, snapshot) {
                String imageUrl =
                    'https://ui-avatars.com/api/?name=${user.displayName ?? 'U'}';
                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  if (data['profileImage'] != null &&
                      data['profileImage'].toString().isNotEmpty) {
                    imageUrl = data['profileImage'];
                  }
                }
                return CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(imageUrl),
                );
              },
            ),
            const SizedBox(width: 8),
            Text("Community Chat",
                style: GoogleFonts.poppins(color: Colors.white)),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chat')
                  .orderBy('timestamp', descending: true)
                  .limit(50)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    var msg = messages[i];
                    bool isMe = msg['uid'] == user.uid;
                    String messageUserId = msg['uid'] ?? '';

                    DateTime ts =
                        (msg['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
                    String formattedTime = DateFormat('hh:mm a').format(ts);

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(messageUserId)
                          .get(),
                      builder: (context, userSnapshot) {
                        String userImage = '';
                        if (userSnapshot.hasData && userSnapshot.data!.exists) {
                          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                          userImage = userData['userImage'] ?? '';
                        }

                        return Container(
                          margin: EdgeInsets.only(
                            top: 6,
                            bottom: 6,
                            left: isMe ? 60 : 12,
                            right: isMe ? 12 : 60,
                          ),
                          child: Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Show avatar on left for others
                              if (!isMe) ...[
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFF1E1B4B),
                                  backgroundImage: userImage.isNotEmpty
                                      ? MemoryImage(base64Decode(userImage))
                                      : null,
                                  child: userImage.isEmpty
                                      ? Text(
                                    (msg['name'] ?? 'U')[0].toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : null,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: isMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(msg['name'] ?? 'Unknown',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12, color: Colors.white70)),
                                    const SizedBox(height: 2),
                                    Material(
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(18),
                                        topRight: const Radius.circular(18),
                                        bottomLeft:
                                        Radius.circular(isMe ? 18 : 0),
                                        bottomRight:
                                        Radius.circular(isMe ? 0 : 18),
                                      ),
                                      elevation: 2,
                                      color: isMe
                                          ? const Color(0xFFD946EF)
                                          : const Color(0xFF1E1B4B),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(msg['message'] ?? '',
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white, fontSize: 16)),
                                            const SizedBox(height: 4),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(formattedTime,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 10,
                                                      color: Colors.white54)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Show avatar on right for current user
                              if (isMe) ...[
                                const SizedBox(width: 8),
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: const Color(0xFFD946EF),
                                  backgroundImage: userImage.isNotEmpty
                                      ? MemoryImage(base64Decode(userImage))
                                      : null,
                                  child: userImage.isEmpty
                                      ? Text(
                                    (msg['name'] ?? 'U')[0].toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : null,
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFF1E1B4B),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFD946EF)),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      if (_controller.text.trim().isEmpty) return;
                      FirebaseFirestore.instance.collection('chat').add({
                        'message': _controller.text.trim(),
                        'name': user.displayName ??
                            user.email?.split('@')[0] ??
                            'Anonymous',
                        'uid': user.uid,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      _controller.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}