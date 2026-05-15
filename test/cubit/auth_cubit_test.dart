import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:claude_app_demo/cubit/auth_cubit.dart';
import 'package:claude_app_demo/cubit/auth_state.dart';
import 'package:claude_app_demo/models/user.dart';
import 'package:claude_app_demo/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockService;

  const testUser = User(id: '1', name: 'Test', email: 'test@test.com');
  const testToken = 'jwt123';

  setUp(() {
    mockService = MockAuthService();
  });

  test('initial state is AuthInitial', () {
    final cubit = AuthCubit(mockService);
    expect(cubit.state, isA<AuthInitial>());
    cubit.close();
  });

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(() => mockService.login(any(), any()))
            .thenAnswer((_) async => (testUser, testToken));
        return AuthCubit(mockService);
      },
      act: (c) => c.login('test@test.com', '123456'),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
      verify: (_) {
        verify(() => mockService.login('test@test.com', '123456')).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(() => mockService.login(any(), any()))
            .thenThrow(Exception('Email hoặc mật khẩu không đúng'));
        return AuthCubit(mockService);
      },
      act: (c) => c.login('bad@test.com', 'wrong'),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );

    blocTest<AuthCubit, AuthState>(
      'AuthAuthenticated contains correct user and token',
      build: () {
        when(() => mockService.login(any(), any()))
            .thenAnswer((_) async => (testUser, testToken));
        return AuthCubit(mockService);
      },
      act: (c) => c.login('test@test.com', '123456'),
      verify: (c) {
        final state = c.state as AuthAuthenticated;
        expect(state.user.name, 'Test');
        expect(state.token, testToken);
      },
    );
  });

  group('register', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(() => mockService.register(any(), any(), any()))
            .thenAnswer((_) async => (testUser, testToken));
        return AuthCubit(mockService);
      },
      act: (c) => c.register('Test', 'test@test.com', '123456'),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(() => mockService.register(any(), any(), any()))
            .thenThrow(Exception('Email đã được sử dụng'));
        return AuthCubit(mockService);
      },
      act: (c) => c.register('User', 'exists@test.com', '123456'),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthInitial after logout',
      build: () {
        when(() => mockService.clearSession()).thenAnswer((_) async {});
        return AuthCubit(mockService);
      },
      act: (c) => c.logout(),
      expect: () => [isA<AuthInitial>()],
      verify: (_) {
        verify(() => mockService.clearSession()).called(1);
      },
    );
  });

  group('tryAutoLogin', () {
    blocTest<AuthCubit, AuthState>(
      'emits AuthAuthenticated when session exists',
      build: () {
        when(() => mockService.getSavedSession())
            .thenAnswer((_) async => (testUser, testToken));
        return AuthCubit(mockService);
      },
      act: (c) => c.tryAutoLogin(),
      expect: () => [isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'emits nothing when no session',
      build: () {
        when(() => mockService.getSavedSession()).thenAnswer((_) async => null);
        return AuthCubit(mockService);
      },
      act: (c) => c.tryAutoLogin(),
      expect: () => [],
    );
  });
}
