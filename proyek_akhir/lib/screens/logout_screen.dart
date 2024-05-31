import 'package:flutter/material.dart';
import 'package:proyek_akhir/services/session_manager.dart';
import 'package:proyek_akhir/widgets/bottom_navbar.dart';
import 'package:proyek_akhir/screens/login_screen.dart';

class LogoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(selectedIndex: 2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Are you sure you want to logout?'),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white
              ),
              onPressed: () async {
                await SessionManager.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
