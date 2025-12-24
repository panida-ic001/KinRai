import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _actokenKey = 'fitbit_actoken';
  static const _retokenKey = 'fitbit_retoken';
  static const _userIdKey = 'fitbit_user_id';
  static const _expiresKey = 'fitbit_expires';

  // SAVE
  static Future<void> saveToken({
    required String actoken,
    required String retoken,
    required String userId,
    required String expires,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_actokenKey, actoken);
    await prefs.setString(_retokenKey, retoken);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_expiresKey, expires);
  }

  // READ
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_actokenKey);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_retokenKey);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<String?> getExpies() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_expiresKey);
  }

  // CLEAR (logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_actokenKey);
    await prefs.remove(_retokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_expiresKey);
  }

  // CHECK
  static Future<bool> hasLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_actokenKey) &&
        prefs.containsKey(_retokenKey) &&
        prefs.containsKey(_userIdKey) &&
        prefs.containsKey(_expiresKey);
  }
}
