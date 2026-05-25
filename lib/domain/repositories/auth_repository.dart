import '../entities/user.dart';

abstract class AuthRepository {
  Future<(User, String token)> login(String email, String password);
  Future<(User, String token)> register(String name, String email, String password);
  Future<(User, String token, bool isNewUser)> socialLogin(String provider, String token);
  Future<(User, String token)?> getSavedSession();
  Future<void> clearSession();
}
