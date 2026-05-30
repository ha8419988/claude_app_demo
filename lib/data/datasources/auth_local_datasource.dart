import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession(UserModel user, String token, {bool isProfileComplete = false});
  Future<(UserModel, String, bool)?> getSession();
  Future<void> setProfileComplete();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';
  static const _profileCompleteKey = 'auth_profile_complete';

  @override
  Future<void> saveSession(UserModel user, String token, {bool isProfileComplete = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(_profileCompleteKey, isProfileComplete);
  }

  @override
  Future<(UserModel, String, bool)?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (token == null || userJson == null) return null;
    final user = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    final isProfileComplete = prefs.getBool(_profileCompleteKey) ?? false;
    return (user, token, isProfileComplete);
  }

  @override
  Future<void> setProfileComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_profileCompleteKey, true);
  }

  @override
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_profileCompleteKey);
  }
}
