import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SocialLoginUseCase {
  final AuthRepository _repository;
  SocialLoginUseCase(this._repository);

  Future<(User, String token, bool isNewUser, bool isProfileComplete)> call(
          String provider, String token) =>
      _repository.socialLogin(provider, token);
}
