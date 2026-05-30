import '../entities/user.dart';

abstract class AuthRepository {
  Future<(User, String token, bool isProfileComplete)> login(String email, String password);
  Future<(User, String token)> register(String name, String email, String password);
  Future<(User, String token, bool isNewUser, bool isProfileComplete)> socialLogin(String provider, String token);
  Future<(User, String token, bool isProfileComplete)?> getSavedSession();
  Future<void> completeProfile(String token);
  Future<void> clearSession();
}
