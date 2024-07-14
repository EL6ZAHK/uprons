import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'author.dart';

class UserPreferences {
  static late SharedPreferences preferences;
  static const keyUser = 'user';

  static Future init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future setUser(Author author) async {
    final json = jsonEncode(author.toJson());
    await preferences.setString(keyUser, json);
  }

  static Future signOut() async {
    await preferences.clear();
  }

  static Author? getUser() {
    final json = preferences.getString(keyUser);
    return json == null ? null : Author.fromJson(jsonDecode(json));
  }
}
