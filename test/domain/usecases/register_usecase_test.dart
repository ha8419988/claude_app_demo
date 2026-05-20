import 'package:claude_app_demo/domain/entities/user.dart';
import 'package:claude_app_demo/domain/repositories/auth_repository.dart';
import 'package:claude_app_demo/domain/usecases/register_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository repository;

  const tUser = User(id: '1', name: 'Anh', email: 'a@gmail.com');
  const tToken = 'token123';

  setUp(() {
    repository = MockAuthRepository();
    useCase = RegisterUseCase(repository);
  });

  test('calls repository.register and returns (User, token)', () async {
    when(() => repository.register('Anh', 'a@gmail.com', '123456'))
        .thenAnswer((_) async => (tUser, tToken));

    final result = await useCase('Anh', 'a@gmail.com', '123456');

    expect(result, equals((tUser, tToken)));
    verify(() => repository.register('Anh', 'a@gmail.com', '123456')).called(1);
  });
}
