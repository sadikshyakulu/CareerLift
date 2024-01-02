import 'package:app_jobdirect/screens/authenticate/register.dart';
import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class ToggleAuth extends StatefulWidget {
  const ToggleAuth({super.key});

  @override
  State<ToggleAuth> createState() => _ToggleAuthState();
}

class _ToggleAuthState extends State<ToggleAuth> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    }else {
      return Register(toggleView: toggleView);
    }
  }
}
