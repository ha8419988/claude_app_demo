import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;
  const RegisterUseCase(this._repository);

  Future<(User, String)> call(String name, String email, String password) =>
      _repository.register(name, email, password);
}
