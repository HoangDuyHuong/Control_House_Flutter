// lib/local_auth.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple local auth helper that supports MULTIPLE ACCOUNTS using SharedPreferences.
/// Data model in SharedPreferences:
///   - "users_json": JSON object { "<email>": {"password": "...", "name": "..."} }
///   - "current_user": the email of the currently logged-in account
class LocalAuth {
  static const _kUsers = 'users_json';
  static const _kCurrent = 'current_user';

  /// Read users map from SharedPreferences. Returns {} if empty / not set.
  static Future<Map<String, dynamic>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kUsers);
    if (s == null || s.isEmpty) return {};

    try {
      final obj = jsonDecode(s);
      if (obj is Map<String, dynamic>) return obj;
    } catch (_) {}
    return {};
  }

  static Future<void> _saveUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsers, jsonEncode(users));
  }

  /// Creates a new account. Returns false if email already exists.
  static Future<bool> register({
    required String email,
    required String password,
    String? name,
  }) async {
    final users = await _getUsers();
    if (users.containsKey(email)) return false;
    users[email] = {'password': password, 'name': name ?? ''};
    await _saveUsers(users);
    return true;
  }

  /// Authenticates an account. Returns true on success.
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final users = await _getUsers();
    final u = users[email];
    if (u is Map && u['password'] == password) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kCurrent, email);
      return true;
    }
    return false;
  }

  /// Clears the current user (does NOT delete the account)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCurrent);
  }

  /// Returns the email of the currently logged-in account, or null.
  static Future<String?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kCurrent);
  }

  /// List all stored account emails.
  static Future<List<String>> allEmails() async {
    final users = await _getUsers();
    return users.keys.cast<String>().toList()..sort();
  }

  /// Permanently delete an account by email. Returns true if removed.
  static Future<bool> deleteUser(String email) async {
    final users = await _getUsers();
    final removed = users.remove(email) != null;
    if (removed) await _saveUsers(users);
    return removed;
  }

  /// (Optional) one-time migration from a legacy single-account storage.
  /// Call this early in app startup if you used to save one email/password.
  static Future<void> migrateLegacyIfAny({
    String emailKey = 'email',
    String passwordKey = 'password',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = await _getUsers();
    final legacyEmail = prefs.getString(emailKey);
    final legacyPass  = prefs.getString(passwordKey);
    if (legacyEmail != null && legacyPass != null && !users.containsKey(legacyEmail)) {
      users[legacyEmail] = {'password': legacyPass, 'name': ''};
      await _saveUsers(users);
      // Optionally clear legacy keys:
      // await prefs.remove(emailKey);
      // await prefs.remove(passwordKey);
    }
  }
}