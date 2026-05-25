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
  Future<(User, String)> login(String email, String password) async {
    final (user, token) = await _remote.login(email, password);
    await _local.saveSession(user, token);
    return (user, token);
  }

  @override
  Future<(User, String)> register(
      String name, String email, String password) async {
    final (user, token) = await _remote.register(name, email, password);
    await _local.saveSession(user, token);
    return (user, token);
  }

  @override
  Future<(User, String, bool)> socialLogin(String provider, String token) async {
    final (user, jwt, isNewUser) = await _remote.socialLogin(provider, token);
    await _local.saveSession(user, jwt);
    return (user, jwt, isNewUser);
  }

  @override
  Future<(User, String)?> getSavedSession() => _local.getSession();

  @override
  Future<void> clearSession() => _local.clearSession();
}
