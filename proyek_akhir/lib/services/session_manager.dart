import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final String _isLoggedInKey = 'isLoggedIn';
  static final String _usernameKey = 'username';

  // method untuk mengubah status login
  static Future<void> setLoggedIn(String username, bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // method untuk mengambil username yang sedang aktif / login
  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  // method untuk cek status login
  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // method untuk logout
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await setLoggedIn('', false);
  }
}