import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sloboda/models/sloboda.dart';

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

  Sloboda readSloboda() {
    var s = _preferences.getString("saved_sloboda");
    var map = jsonDecode(s);
    return Sloboda.fromJson(map);
  }

  Future saveSloboda(Sloboda city) async {
    var json = city.toJson();
    return await _preferences.setString("saved_sloboda", json.toString());
  }
}
