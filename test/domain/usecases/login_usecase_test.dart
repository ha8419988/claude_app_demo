import 'package:claude_app_demo/domain/entities/user.dart';
import 'package:claude_app_demo/domain/repositories/auth_repository.dart';
import 'package:claude_app_demo/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository repository;

  const tUser = User(id: '1', name: 'Anh', email: 'a@gmail.com');
  const tToken = 'token123';

  setUp(() {
    repository = MockAuthRepository();
    useCase = LoginUseCase(repository);
  });

  test('calls repository.login and returns (User, token)', () async {
    when(() => repository.login('a@gmail.com', '123456'))
        .thenAnswer((_) async => (tUser, tToken, false));

    final result = await useCase('a@gmail.com', '123456');

    expect(result, equals((tUser, tToken, false)));
    verify(() => repository.login('a@gmail.com', '123456')).called(1);
  });

  test('propagates exception from repository', () async {
    when(() => repository.login(any(), any()))
        .thenThrow(Exception('Sai mật khẩu'));

    expect(() => useCase('a@gmail.com', 'wrong'), throwsException);
  });
}
