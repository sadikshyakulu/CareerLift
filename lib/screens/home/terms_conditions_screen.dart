import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to Our App!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Please read our terms and conditions carefully before using our app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
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
