import 'package:hive/hive.dart';
import 'package:proyek_akhir/models/user.dart';
import 'package:proyek_akhir/services/session_manager.dart';

class UserManager {
  static Box<User> _userBox = Hive.box<User>('users');

  static Future<bool> createUser(String? username, String? password) async {
    if (_userBox.containsKey(username)) {
      return false; // username sudah ada
    }
    final newUser = User(username!, password!, []);
    await _userBox.put(username, newUser);
    return true;
  }

  static Future<bool> checkCredentials(String username, String password) async {
    final user = _userBox.get(username);
    if (user != null && user.password == password) {
      await SessionManager.setLoggedIn(username, true); // set login status menjadi true
      return true;
    }
    return false;
  }

  static Future<User?> getUser(String username) async {
    final user = _userBox.get(username);
    return user;
  }

  static Future<bool> addFavorite(String username, int movieId) async {
    final user = _userBox.get(username);
    if (user != null) {
      final updatedUser = User(user.username, user.password, List.from(user.favoriteMovieIds)..add(movieId));
      await _userBox.put(username, updatedUser);
      return true;
    }
    return false;
  }

  static Future<bool> removeFavorite(String username, int movieId) async {
    final user = _userBox.get(username);
    if (user != null) {
      final updatedUser = User(user.username, user.password, List.from(user.favoriteMovieIds)..remove(movieId));
      await _userBox.put(username, updatedUser);
      return true;
    }
    return false;
  }

  static Future<List<int>?> getFavorites(String username) async {
    final user = _userBox.get(username);
    return user?.favoriteMovieIds;
  }

  static Future<bool> isFavorite(String username, int movieId) async {
    final user = _userBox.get(username);
    if (user != null) {
      return user.favoriteMovieIds.contains(movieId);
    }
    return false;
  }

  static Future<List<User>> getAllUsers() async {
    final users = _userBox.values.toList();
    return users;
  }

  static Future<bool> hasUsers() async {
    final isEmpty = _userBox.isEmpty;
    return !isEmpty;
  }
}