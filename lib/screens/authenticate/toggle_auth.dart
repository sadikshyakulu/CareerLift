// toggle_auth.dart
import 'package:app_jobdirect/screens/authenticate/register.dart';
import 'package:app_jobdirect/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class ToggleAuth extends StatefulWidget {
  const ToggleAuth({Key? key}) : super(key: key);

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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: showSignIn ? const Offset(1.0, 0.0) : const Offset(-1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: showSignIn
          ? SignIn(key: const ValueKey('SignIn'), onToggle: toggleView)
          : Register(key: const ValueKey('Register'), onToggle: toggleView),
    );
  }
}