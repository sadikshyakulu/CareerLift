import 'package:flutter/material.dart';

class ProfileConfiguration extends StatefulWidget {
  const ProfileConfiguration({super.key});

  @override
  State<ProfileConfiguration> createState() => _ProfileConfigurationState();
}

class _ProfileConfigurationState extends State<ProfileConfiguration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload jobs'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(7.0),
          child: Card(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                ],
              ),
            ),
          ),

        ),
      ),
    );
  }
}
