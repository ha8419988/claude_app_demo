import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/remote/auth_api.dart';
import '../data/remote/dto/auth_request.dart';
import '../models/user.dart';

class AuthService {
  final AuthApi _api;
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  AuthService(this._api);

  Future<(User, String)> login(String email, String password) async {
    try {
      final resp = await _api.login(LoginRequest(email: email, password: password));
      final user = User(id: resp.user.id, name: resp.user.name, email: resp.user.email);
      await _saveSession(user, resp.token);
      return (user, resp.token);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  Future<(User, String)> register(String name, String email, String password) async {
    try {
      final resp = await _api.register(RegisterRequest(name: name, email: email, password: password));
      final user = User(id: resp.user.id, name: resp.user.name, email: resp.user.email);
      await _saveSession(user, resp.token);
      return (user, resp.token);
    } on DioException catch (e) {
      throw Exception(_extractError(e));
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic> && data['error'] != null) {
      return data['error'] as String;
    }
    return 'Không kết nối được server. Vui lòng kiểm tra lại.';
  }

  Future<void> _saveSession(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  Future<(User, String)?> getSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    if (token == null || userJson == null) return null;
    return (User.fromJson(jsonDecode(userJson) as Map<String, dynamic>), token);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
