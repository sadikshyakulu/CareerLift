import 'package:app_jobdirect/screens/shared/loading_animation.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function? toggleView; // Use Function?

  SignIn({this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;


  // text field state
  String email =  '';
  String password = '';
  String err = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    Widget buildInputField(String hintText, bool obscure, void Function(String) onChanged) {
      return TextFormField(
        validator: (val) {
          if (val!.isEmpty) {
            return 'Enter a $hintText';
          } else if (val.length < 6 && hintText == 'Password') {
            return 'Enter a password 6 characters or longer';
          }
          return null;
        },
        onChanged: onChanged,
        obscureText: obscure,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          labelText: hintText, // Added labelText for clarity
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    }

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[400],
        elevation: 0.0,
        title: const Text("Sign In"),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    widget.toggleView!();
                  },
                  icon: Icon(Icons.person)
              ),
              Text('Register')
            ],
          )
        ],
      ),
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //image logo
                  SizedBox(height: size.height/35),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.lightBlueAccent,
                        borderRadius: BorderRadius.circular(30)),
                    height: size.height / 2,
                    width: size.width / 1.5,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: size.height/35),
                          buildInputField('Email', false, (val) {
                          setState(() => email = val);
                          }),
                          SizedBox(height: size.height/35),
                          buildInputField('Password', true, (val) {
                            setState(() => password = val);
                          }),
                          SizedBox(height: size.height/35),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                // Handle sign-in logic
                                if (_formKey.currentState?.validate() ?? false) {
                                  setState(() => loading = true
                                  );
                                  // dynamic result = await _auth.signinWithEmailAndPassword(email, password);
                                  // if (result == null) {
                                  //   setState(() => err = 'Could not sign in with the credentials');
                                  //   loading = false;
                                  // }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Sign In'),
                            ),
                          ),
                          SizedBox(
                            height: size.height/35,
                          ),
                          Center(
                            child: Text(
                              err,
                              style: TextStyle(
                                  color: Colors.red
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
          )
      )
    );
  }
}
