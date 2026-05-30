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
  late MockSocialLoginUseCase mockSocialLogin;

  const fakeUser = User(id: '1', name: 'Test User', email: 'test@test.com');

  setUp(() {
    mockSocialLogin = MockSocialLoginUseCase();
    cubit = AuthCubit(
      loginUseCase: MockLoginUseCase(),
      registerUseCase: MockRegisterUseCase(),
      autoLoginUseCase: MockAutoLoginUseCase(),
      logoutUseCase: MockLogoutUseCase(),
      socialLoginUseCase: mockSocialLogin,
      completeProfileUseCase: MockCompleteProfileUseCase(),
    );
  });

  tearDown(() => cubit.close());

  group('socialLogin', () {
    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Authenticated(isNewUser:true)] khi user mới',
      build: () {
        when(() => mockSocialLogin('google', 'valid_token'))
            .thenAnswer((_) async => (fakeUser, 'jwt', true, false));
        return cubit;
      },
      act: (c) => c.socialLogin('google', 'valid_token'),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(user: fakeUser, token: 'jwt', isNewUser: true),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Loading, Authenticated(isNewUser:false)] khi user cũ',
      build: () {
        when(() => mockSocialLogin('facebook', 'fb_token'))
            .thenAnswer((_) async => (fakeUser, 'jwt', false, false));
        return cubit;
      },
      act: (c) => c.socialLogin('facebook', 'fb_token'),
      expect: () => [
        const AuthLoading(),
        const AuthAuthenticated(user: fakeUser, token: 'jwt'),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits [Loading, AuthError] khi token không hợp lệ',
      build: () {
        when(() => mockSocialLogin('google', 'bad_token'))
            .thenThrow(Exception('Token Google không hợp lệ'));
        return cubit;
      },
      act: (c) => c.socialLogin('google', 'bad_token'),
      expect: () => [
        const AuthLoading(),
        const AuthError('Token Google không hợp lệ'),
      ],
    );
  });
}
