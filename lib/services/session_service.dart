import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _keyEmail = 'email';

  static Future<void> login(String email) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_keyEmail, email);
  }

  static Future<String?> getEmail() async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_keyEmail);
  }

  static Future<void> logout() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_keyEmail);
  }
}
