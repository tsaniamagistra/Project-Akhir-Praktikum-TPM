import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:proyek_akhir/colors.dart';
import 'package:proyek_akhir/models/user.dart';
import 'package:proyek_akhir/screens/favorite_screen.dart';
import 'package:proyek_akhir/screens/home_screen.dart';
import 'package:proyek_akhir/screens/login_screen.dart';
import 'package:proyek_akhir/screens/logout_screen.dart';
import 'package:proyek_akhir/services/session_manager.dart';
import 'package:proyek_akhir/devices/app_initializer.dart' as initializer;
import 'package:proyek_akhir/services/user_manager.dart';

void main() async {
  // memastikan binding flutter telah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  await initializer.initHive();

  // daftarkan adapter untuk model user
  Hive.registerAdapter(UserAdapter());

  // buka box
  await Hive.openBox<User>('users');

  if (await UserManager.hasUsers()) {
    print('There are users in the box');
    List<User> users = await UserManager.getAllUsers();
    users.forEach((user) {
      print('User: ${user.username}, Favorites: ${user.favoriteMovieIds}');
    });
  } else {
    print('No users found');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proyek Akhir',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colours.scaffoldBgColor,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[50],
            foregroundColor: Colors.black,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.red,
        ),
      ),
      // routes dimanfaatkan untuk bottom navbar
      routes: {
        '/home': (context) => HomeScreen(),
        '/favorite': (context) => FavoriteScreen(),
        '/logout': (context) => LogoutScreen(),
      },
      home: FutureBuilder<bool>(
        future: SessionManager.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final bool isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? HomeScreen() : LoginScreen();
          }
        },
      ),
    );
  }
}

// fungsi utama untuk menjalankan program
