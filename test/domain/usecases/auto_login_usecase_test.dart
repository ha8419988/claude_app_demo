import 'package:claude_app_demo/domain/entities/user.dart';
import 'package:claude_app_demo/domain/repositories/auth_repository.dart';
import 'package:claude_app_demo/domain/usecases/auto_login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AutoLoginUseCase useCase;
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
    useCase = AutoLoginUseCase(repository);
  });

  test('returns saved session when it exists', () async {
    const tUser = User(id: '1', name: 'Anh', email: 'a@gmail.com');
    when(() => repository.getSavedSession())
        .thenAnswer((_) async => (tUser, 'token123'));

    final result = await useCase();

    expect(result, isNotNull);
    expect(result!.$1, equals(tUser));
  });

  test('returns null when no session saved', () async {
    when(() => repository.getSavedSession()).thenAnswer((_) async => null);

    final result = await useCase();

    expect(result, isNull);
  });
}
