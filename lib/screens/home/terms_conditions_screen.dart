import 'package:flutter/material.dart';

// This class represents the Terms and Conditions page of the application.
class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold widget provides the basic structure of the page.
    return Scaffold(
      appBar: AppBar(
        // AppBar displays the title of the page.
        title: Text('Terms and Conditions'),
      ),
      body: Padding(
        // Padding for additional spacing around the content.
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // SingleChildScrollView allows scrolling if the content exceeds the screen height.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message at the beginning of the Terms and Conditions page.
              Text(
                'Welcome to Our App!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),  // Vertical spacing between sections.

              // Introduction to the purpose of reading terms and conditions.
              Text(
                'Please read our terms and conditions carefully before using our app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Section 1: Acceptance of Terms.
              Text(
                '1. Acceptance of Terms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'By using this app, you agree to be bound by these terms and conditions.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),

              // Section 2: Use of the App.
              Text(
                '2. Use of the App',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'You agree not to misuse the app or engage in any activity that may interfere with its proper functioning.',
                style: TextStyle(fontSize: 16),
              ),
              // Add more sections as needed...

              SizedBox(height: 16),

              // Section 3: Contact Us.
              Text(
                '3. Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions about these terms, please contact us at blabla@blabla.com.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
