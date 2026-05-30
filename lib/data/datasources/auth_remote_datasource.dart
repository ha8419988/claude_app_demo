import 'package:dio/dio.dart';
import '../../core/error/app_exception.dart';
import '../../data/remote/auth_api.dart';
import '../../data/remote/dto/auth_request.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<(UserModel, String, bool)> login(String email, String password);
  Future<(UserModel, String)> register(String name, String email, String password);
  Future<(UserModel, String, bool, bool)> socialLogin(String provider, String token);
  Future<void> completeProfile(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApi _api;
  AuthRemoteDataSourceImpl(this._api);

  @override
  Future<(UserModel, String, bool)> login(String email, String password) async {
    try {
      final resp = await _api.login(LoginRequest(email: email, password: password));
      return (UserModel.fromJson(resp.user.toJson()), resp.token, resp.isProfileComplete);
    } on DioException catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  @override
  Future<(UserModel, String)> register(
      String name, String email, String password) async {
    try {
      final resp = await _api.register(
          RegisterRequest(name: name, email: email, password: password));
      return (UserModel.fromJson(resp.user.toJson()), resp.token);
    } on DioException catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  @override
  Future<(UserModel, String, bool, bool)> socialLogin(
      String provider, String token) async {
    try {
      final resp = await _api.socialLogin(
          SocialLoginRequest(provider: provider, token: token));
      return (UserModel.fromJson(resp.user.toJson()), resp.token, resp.isNewUser, resp.isProfileComplete);
    } on DioException catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  @override
  Future<void> completeProfile(String token) async {
    try {
      await _api.completeProfile('Bearer $token');
    } on DioException catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  String _extractMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic> && data['error'] != null) {
      return data['error'] as String;
    }
    return 'Không kết nối được server. Vui lòng kiểm tra lại.';
  }
}
