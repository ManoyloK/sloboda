import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  AppPreferences._internal();

  static final AppPreferences instance = AppPreferences._internal();
  SharedPreferences _preferences;
  String _isDarkTheme = 'isDarkTheme';
  String _languageCode = 'languageCode';

  Future init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      return _preferences;
    } catch (e) {
      print(e);
      return {};
    }
  }

  bool getDarkTheme() {
    return _preferences.getBool(_isDarkTheme) ?? false;
  }

  Future setDarkTheme(bool isDarkTheme) async {
    return await _preferences.setBool(_isDarkTheme, isDarkTheme);
  }

  String getUILanguage() {
    return _preferences.getString(_languageCode);
  }

  Future setUILanguage(String languageCode) async {
    return await _preferences.setString(_languageCode, languageCode);
  }

  Map<String, dynamic> readSloboda() {
    try {
      var s = _preferences.getString("saved_sloboda");
      if (s != null) {
        var map = jsonDecode(s);
        return map;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future saveSloboda(Map<String, dynamic> json) async {
    var string = jsonEncode(json);
    try {
      return await _preferences.setString("saved_sloboda", string);
    } catch (e) {
      return null;
    }
  }

  Future<bool> removeSavedSloboda() async {
    return await _preferences.remove("saved_sloboda");
  }
}
