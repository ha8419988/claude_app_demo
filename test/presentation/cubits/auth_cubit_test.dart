import 'package:bloc_test/bloc_test.dart';
import 'package:claude_app_demo/cubit/auth_cubit.dart';
import 'package:claude_app_demo/cubit/auth_state.dart';
import 'package:claude_app_demo/domain/entities/user.dart';
import 'package:claude_app_demo/domain/usecases/auto_login_usecase.dart';
import 'package:claude_app_demo/domain/usecases/complete_profile_usecase.dart';
import 'package:claude_app_demo/domain/usecases/login_usecase.dart';
import 'package:claude_app_demo/domain/usecases/logout_usecase.dart';
import 'package:claude_app_demo/domain/usecases/register_usecase.dart';
import 'package:claude_app_demo/domain/usecases/social_login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockAutoLoginUseCase extends Mock implements AutoLoginUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockSocialLoginUseCase extends Mock implements SocialLoginUseCase {}
class MockCompleteProfileUseCase extends Mock implements CompleteProfileUseCase {}

void main() {
  late AuthCubit cubit;
  late MockLoginUseCase loginUseCase;
  late MockRegisterUseCase registerUseCase;
  late MockAutoLoginUseCase autoLoginUseCase;
  late MockLogoutUseCase logoutUseCase;

  const tUser = User(id: '1', name: 'Anh', email: 'a@gmail.com');
  const tToken = 'token123';

  setUp(() {
    loginUseCase = MockLoginUseCase();
    registerUseCase = MockRegisterUseCase();
    autoLoginUseCase = MockAutoLoginUseCase();
    logoutUseCase = MockLogoutUseCase();
    cubit = AuthCubit(
      loginUseCase: loginUseCase,
      registerUseCase: registerUseCase,
      autoLoginUseCase: autoLoginUseCase,
      logoutUseCase: logoutUseCase,
      socialLoginUseCase: MockSocialLoginUseCase(),
      completeProfileUseCase: MockCompleteProfileUseCase(),
    );
  });

  tearDown(() => cubit.close());

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthAuthenticated] on success',
      build: () {
        when(() => loginUseCase('a@gmail.com', '123456'))
            .thenAnswer((_) async => (tUser, tToken, false));
        return cubit;
      },
      act: (c) => c.login('a@gmail.com', '123456'),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(user: tUser, token: tToken),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(() => loginUseCase(any(), any()))
            .thenThrow(Exception('Sai mật khẩu'));
        return cubit;
      },
      act: (c) => c.login('a@gmail.com', 'wrong'),
      expect: () => [
        const AuthLoading(),
        const AuthError('Sai mật khẩu'),
      ],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthInitial] after logout',
      build: () {
        when(() => logoutUseCase()).thenAnswer((_) async {});
        return cubit;
      },
      act: (c) => c.logout(),
      expect: () => [const AuthInitial()],
    );
  });

  group('tryAutoLogin', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthAuthenticated] when session exists',
      build: () {
        when(() => autoLoginUseCase())
            .thenAnswer((_) async => (tUser, tToken, false));
        return cubit;
      },
      act: (c) => c.tryAutoLogin(),
      expect: () => [AuthAuthenticated(user: tUser, token: tToken)],
    );

    blocTest<AuthCubit, AuthState>(
      'emits nothing when no session',
      build: () {
        when(() => autoLoginUseCase()).thenAnswer((_) async => null);
        return cubit;
      },
      act: (c) => c.tryAutoLogin(),
      expect: () => [],
    );
  });
}
