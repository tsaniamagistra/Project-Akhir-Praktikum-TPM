import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:proyek_akhir/models/user.dart';
import 'package:proyek_akhir/screens/home_screen.dart';
import 'package:proyek_akhir/screens/signup_screen.dart';
import 'package:proyek_akhir/services/user_manager.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = "";
  String password = "";
  bool isLoginSuccess = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              SizedBox(height: 10),
              _signUpLink(),
              SizedBox(height: 10),
              _loginButton(context),
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

  Widget _loginButton(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          String text = "";

          if (username.isEmpty || password.isEmpty) {
            text = "Username and password cannot be empty";
            isLoginSuccess = false;
          }
          else if (await UserManager.checkCredentials(username, password)) {
            text = "Login successful";
            isLoginSuccess = true;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else {
            text = "Login failed";
            isLoginSuccess = false;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(text, style: TextStyle(color: Colors.white)),
              backgroundColor: (isLoginSuccess) ? Colors.green : Colors.red,
            ),
          );
        },
        child: Text(
          'Login',
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

  Widget _signUpLink() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpScreen()),
        );
      },
      child: Text(
        'Don\'t have an account? Sign Up',
        style: TextStyle(
          fontSize: 11.0,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
