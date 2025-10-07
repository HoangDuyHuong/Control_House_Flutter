import 'package:shared_preferences/shared_preferences.dart';

class LocalAuth {
  static const _kUsername = 'username';
  static const _kEmail = 'email';
  static const _kPassword = 'password';
  static const _kLoggedIn = 'loggedIn';

  static Future<void> saveAccount({
    required String username,
    required String email,
    required String password,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kUsername, username);
    await p.setString(_kEmail, email);
    await p.setString(_kPassword, password);
  }

  static Future<bool> validateLogin({
    required String email,
    required String password,
  }) async {
    final p = await SharedPreferences.getInstance();
    final savedEmail = p.getString(_kEmail);
    final savedPass  = p.getString(_kPassword);
    return (email == savedEmail && password == savedPass);
  }

  static Future<String?> getSavedEmail() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kEmail);
  }

  static Future<String?> getSavedPassword() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kPassword);
  }

  static Future<void> setLoggedIn(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kLoggedIn, v);
  }

  static Future<void> logout() async => setLoggedIn(false);
}
