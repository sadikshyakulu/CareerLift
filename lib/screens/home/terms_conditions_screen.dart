// terms_conditions_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Terms & Conditions",
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F0A2C), Color(0xFF1A0B3E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Hero Header
              Container(
                height: 220,
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA855F7), Color(0xFF9D4EDD)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF9D4EDD).withOpacity(0.6),
                      blurRadius: 50,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFD946EF).withOpacity(0.2),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.gavel_rounded, size: 80, color: Colors.white.withOpacity(0.9)),
                          const SizedBox(height: 16),
                          Text(
                            "Terms of Service",
                            style: GoogleFonts.jomhuria(fontSize: 48, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Last updated: November 2025",
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Scrollable Content with Glassmorphic Card
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle("1. Acceptance of Terms"),
                        _sectionBody(
                          "By accessing or using CareerLift, you agree to be bound by these Terms and Conditions. "
                              "If you do not agree with any part of these terms, you may not use our service.",
                        ),

                        _sectionTitle("2. Use of the App"),
                        _sectionBody(
                          "• You must be at least 16 years old to use this app.\n"
                              "• You are responsible for maintaining the confidentiality of your account.\n"
                              "• You agree not to misuse the app or interfere with its proper functioning.\n"
                              "• Posting fake jobs, spam, or inappropriate content will result in immediate account termination.",
                        ),

                        _sectionTitle("3. Job Postings & Applications"),
                        _sectionBody(
                          "• Employers are solely responsible for the accuracy of job postings.\n"
                              "• Applicants must provide truthful information.\n"
                              "• CareerLift is not responsible for hiring decisions.",
                        ),

                        _sectionTitle("4. Privacy"),
                        _sectionBody(
                          "Your personal data is protected under our Privacy Policy. "
                              "We do not sell your data. All information is used solely to improve your experience and connect you with opportunities.",
                        ),

                        _sectionTitle("5. Limitation of Liability"),
                        _sectionBody(
                          "CareerLift is provided 'as is'. We make no warranties about uninterrupted or error-free service. "
                              "We are not liable for any indirect, incidental, or consequential damages.",
                        ),

                        _sectionTitle("6. Changes to Terms"),
                        _sectionBody(
                          "We reserve the right to modify these terms at any time. Continued use of the app after changes constitutes acceptance of the new terms.",
                        ),

                        _sectionTitle("7. Contact Us"),
                        _sectionBody(
                          "Have questions?\n"
                              "Email: support@careerlift.app\n"
                              "We're here to help 24/7",
                        ),

                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            "Thank you for being part of CareerLift!",
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFD946EF),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFD946EF),
        ),
      ),
    );
  }

  Widget _sectionBody(String content) {
    return Text(
      content,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white.withOpacity(0.9),
        height: 1.6,
      ),
    );
  }
}