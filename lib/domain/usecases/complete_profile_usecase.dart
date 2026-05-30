import '../repositories/auth_repository.dart';

class CompleteProfileUseCase {
  final AuthRepository _repository;
  CompleteProfileUseCase(this._repository);

  Future<void> call(String token) => _repository.completeProfile(token);
}
