import '../entities/user.dart';

abstract class AuthRepository {
  /// Throws [AppException] on failure.
  Future<(User, String token)> login(String email, String password);

  /// Throws [AppException] on failure.
  Future<(User, String token)> register(String name, String email, String password);

  /// Returns null if no saved session exists.
  Future<(User, String token)?> getSavedSession();

  Future<void> clearSession();
}
