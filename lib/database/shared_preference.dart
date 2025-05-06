import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? prefs;

  static const String _themeMode = 'themeMode';
  static const String _language = 'language';
  static const String _onBoard = 'onBoard';
  static const String userData = 'userData';

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setThemeMode(bool value) async {
    return await prefs?.setBool(_themeMode, value) ?? false;
  }

  static bool? getThemeMode() {
    return prefs?.getBool(_themeMode);
  }

  static Future<bool> removeThemeMode() async {
    return await prefs?.remove(_themeMode) ?? false;
  }

  static Future<void> saveLanguage(String languageCode) async {
    await prefs?.setString(_language, languageCode);
  }

  static String? getLanguage() {
    return prefs?.getString(_language);
  }

  static Future<bool> setOnBoard(bool value) async {
    return await prefs?.setBool(_onBoard, value) ?? false;
  }

  static bool? getOnBoard() {
    return prefs?.getBool(_onBoard);
  }

  static Future<void> saveUserData(String data) async {
    await prefs?.setString(userData, data);
  }

  static String? getUserData() {
    return prefs?.getString(userData);
  }

  static Future<bool?> clearData()async{
    return await prefs?.remove(userData);
  }
}
