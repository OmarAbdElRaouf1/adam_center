import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_one_test/features/auth/data/models/user_model.dart';

abstract class UserSessionCache {
  Future<void> saveUser(UserModel user);
  UserModel? getUser();
  Future<void> clearUser();
  Future<void> setLoggedIn(bool value);
  bool isLoggedIn();
}

class UserSessionCacheImpl implements UserSessionCache {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  final SharedPreferences prefs;
  UserSessionCacheImpl(this.prefs);

  @override
  Future<void> saveUser(UserModel user) {
    return prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  UserModel? getUser() {
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw));
  }

  @override
  Future<void> clearUser() async {
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  @override
  Future<void> setLoggedIn(bool value) {
    return prefs.setBool(_isLoggedInKey, value);
  }

  @override
  bool isLoggedIn() {
    if (!(prefs.getBool(_isLoggedInKey) ?? false)) return false;
    final user = getUser();
    return user != null && user.customerId != 0;
  }
}
