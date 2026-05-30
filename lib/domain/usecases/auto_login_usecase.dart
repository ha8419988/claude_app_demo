import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AutoLoginUseCase {
  final AuthRepository _repository;
  const AutoLoginUseCase(this._repository);

  Future<(User, String, bool)?> call() => _repository.getSavedSession();
}
