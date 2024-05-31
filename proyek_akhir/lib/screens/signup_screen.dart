import 'package:flutter/material.dart';
import 'package:proyek_akhir/colors.dart';
import 'package:proyek_akhir/screens/login_screen.dart';
import 'package:proyek_akhir/services/user_manager.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String username = "";
  String password = "";
  bool isSignupSuccess = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/getplix.png',
                fit: BoxFit.cover,
                height: 180,
                filterQuality: FilterQuality.high,
              ),
              _usernameField(),
              _passwordField(),
              SizedBox(height: 20),
              _signupButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _usernameField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        onChanged: (value) => username = value,
        decoration: InputDecoration(
          labelText: 'Username',
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        onChanged: (value) => password = value,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
      ),
    );
  }

  Widget _signupButton(context) {
    String text = "";

    return Container(
      child: ElevatedButton(
        onPressed: () async {
          if (username.isEmpty || password.isEmpty) {
            text = "Username and password cannot be empty.";
            isSignupSuccess = false;
          } else {
            isSignupSuccess = await UserManager.createUser(username, password);
            text = isSignupSuccess ? "Sign up successful" : "Failed to create account, username is already in use";
            if (isSignupSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to login screen
              );
            }
          }

          SnackBar snackBar = SnackBar(
            content: Text(text, style: TextStyle(color: Colors.white)),
            backgroundColor: isSignupSuccess ? Colors.green : Colors.red,
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
        ),
      ),
    );
  }
}
