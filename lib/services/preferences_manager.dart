import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static const String keyCurrency = 'currency';
  static const String keyCategory = 'category';
  static const String keyDarkMode = 'darkMode';

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<String> getCurrency() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(keyCurrency) ?? 'ZMW';
  }

  static Future<void> setCurrency(String currency) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(keyCurrency, currency);
  }

  static Future<String> getCategory() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(keyCategory) ?? 'Food';
  }

  static Future<void> setCategory(String category) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(keyCategory, category);
  }

  static Future<bool> getDarkMode() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool(keyDarkMode) ?? false;
  }

  static Future<void> setDarkMode(bool darkMode) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(keyDarkMode, darkMode);
  }
}
