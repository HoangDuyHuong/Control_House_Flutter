// lib/local_auth.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple local auth helper that supports MULTIPLE ACCOUNTS using SharedPreferences.
/// Data model in SharedPreferences:
///   - "users_json": JSON object { "<email>": {"password": "...", "name": "..."} }
///   - "current_user": the email of the currently logged-in account


//=======================================================================================
// SharePreference là  cơ chế để lưu trữ các dữ liệu đơn giản trên local (bộ nhớ máy chủ)
// khi tắt máy thì bộ nhớ vẫn còn
//=======================================================================================


//====================================================================================
// Bình thường sharePreference không lưu được nhiều cặp key/value, phải dùng các 
// phương pháp quản lý khác để lưu trữ được nhiều thông tin account, có 2 cách:
// 1. Dùng string lưu nhiều cặp key/value nhưng khi đăng nhập sẽ phải theo form email 
// và pass đã lập trình (VD: khi lập trình ta lưu email: HDH@gmail.com  pass:123) 
// thì khi đăng nhập bạn phải nhập đúng chuổi đó -> bất tiện cho user
// 2. Dùng cách quản lý khác đó là lưu nhiều account dưới dạng JSON, khi người dùng 
// đăng ký TK bất kỳ, chương trình sẽ lưu thông tin đó dưới dạng JSON và lưu trữ thành 
// chuỗi, có thể lưu nhiều user và pass word theo ý thích của user -> tiện hơn 
//====================================================================================


class LocalAuth {
  static const _kUsers = 'users_json'; //Lưu 1 chuỗi JSON chứa all tài khoản
  static const _kCurrent = 'current_user'; // lưu user của người đang đăng nhập

  /// Read users map from SharedPreferences. Returns {} if empty / not set.
  /// // Hàm đọc data
  static Future<Map<String, dynamic>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_kUsers);
    if (s == null || s.isEmpty) return {};

    try {
      final obj = jsonDecode(s); // giải mã
      if (obj is Map<String, dynamic>) return obj;
    } catch (_) {}
    return {};
  }

// Hàm ghi/save data
  static Future<void> _saveUsers(Map<String, dynamic> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsers, jsonEncode(users)); // mã hóa
  }

  /// Creates a new account. Returns false if email already exists.
  static Future<bool> register({
    required String email,
    required String password,
    String? name,
  }) async {
    final users = await _getUsers(); // lấy danh sách user cũ lên
    if (users.containsKey(email)) return false; // ktra email đ/ký đã tồn tại?
    users[email] = {'password': password, 'name': name ?? ''};
    await _saveUsers(users); // nếu chưa có thể thêm vào list mới
    return true;
  }

  /// Authenticates an account. Returns true on success.
  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final users = await _getUsers(); // lấy danh sách
    final u = users[email];
    if (u is Map && u['password'] == password) { // so sánh pass user nhập và pass đã lưu trước đó
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kCurrent, email); // nếu đúng thì lưu vào biến _KCurrent
      return true;
    }
    return false;
  }

  /// Clears the current user (does NOT delete the account)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCurrent); // ko phải xóa TK ra khỏi danh sách mà là xóa phiên làm việc
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
    }
  }
}