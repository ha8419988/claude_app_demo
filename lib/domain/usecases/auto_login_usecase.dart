import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AutoLoginUseCase {
  final AuthRepository _repository;
  const AutoLoginUseCase(this._repository);

  Future<(User, String)?> call() => _repository.getSavedSession();
}
