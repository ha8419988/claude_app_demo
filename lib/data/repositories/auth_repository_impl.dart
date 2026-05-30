import 'dart:convert';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  @override
  Future<(User, String, bool)> login(String email, String password) async {
    final (user, token, isProfileComplete) = await _remote.login(email, password);
    await _local.saveSession(user, token, isProfileComplete: isProfileComplete);
    return (user, token, isProfileComplete);
  }

  @override
  Future<(User, String)> register(String name, String email, String password) async {
    final (user, token) = await _remote.register(name, email, password);
    await _local.saveSession(user, token);
    return (user, token);
  }

  @override
  Future<(User, String, bool, bool)> socialLogin(String provider, String token) async {
    final (user, jwt, isNewUser, isProfileComplete) = await _remote.socialLogin(provider, token);
    await _local.saveSession(user, jwt, isProfileComplete: isProfileComplete);
    return (user, jwt, isNewUser, isProfileComplete);
  }

  @override
  Future<(User, String, bool)?> getSavedSession() async {
    final session = await _local.getSession();
    if (session == null) return null;
    final (user, token, isProfileComplete) = session;
    if (_isTokenExpired(token)) {
      await _local.clearSession();
      return null;
    }
    return (user, token, isProfileComplete);
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload['exp'] as int?;
      if (exp == null) return false;
      return DateTime.now().millisecondsSinceEpoch > exp * 1000;
    } catch (_) {
      return true;
    }
  }

  @override
  Future<void> completeProfile(String token) async {
    await _remote.completeProfile(token);
    await _local.setProfileComplete();
  }

  @override
  Future<void> clearSession() => _local.clearSession();
}
