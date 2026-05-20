import 'package:claude_app_demo/domain/repositories/auth_repository.dart';
import 'package:claude_app_demo/domain/usecases/logout_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LogoutUseCase useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = LogoutUseCase(repository);
  });

  test('calls repository.clearSession', () async {
    when(() => repository.clearSession()).thenAnswer((_) async {});

    await useCase();

    verify(() => repository.clearSession()).called(1);
  });
}
