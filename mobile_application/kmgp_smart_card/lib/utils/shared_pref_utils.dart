import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtils {
  static Future<void> saveUserData(
      int? id, String? name, String? photoUrl) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('userId', id ?? -1);
    await prefs.setString('userName', name ?? '');
    await prefs.setString('userPhotoUrl', photoUrl ?? '');
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');

    return userId != null && userId != -1 && userId != 0;
  }

  static Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getInt('userId');

    return userId ?? -1;
  }
}
