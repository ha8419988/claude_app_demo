import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/auto_login_usecase.dart';
import '../domain/usecases/complete_profile_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import '../domain/usecases/social_login_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final AutoLoginUseCase _autoLogin;
  final LogoutUseCase _logout;
  final SocialLoginUseCase _socialLogin;
  final CompleteProfileUseCase _completeProfile;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required AutoLoginUseCase autoLoginUseCase,
    required LogoutUseCase logoutUseCase,
    required SocialLoginUseCase socialLoginUseCase,
    required CompleteProfileUseCase completeProfileUseCase,
  })  : _login = loginUseCase,
        _register = registerUseCase,
        _autoLogin = autoLoginUseCase,
        _logout = logoutUseCase,
        _socialLogin = socialLoginUseCase,
        _completeProfile = completeProfileUseCase,
        super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final (user, token, isProfileComplete) = await _login(email, password);
      emit(AuthAuthenticated(user: user, token: token, isProfileComplete: isProfileComplete));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(const AuthLoading());
    try {
      final (user, token) = await _register(name, email, password);
      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> socialLogin(String provider, String token) async {
    emit(const AuthLoading());
    try {
      final (user, jwt, isNewUser, isProfileComplete) = await _socialLogin(provider, token);
      emit(AuthAuthenticated(user: user, token: jwt, isNewUser: isNewUser, isProfileComplete: isProfileComplete));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> tryAutoLogin() async {
    final session = await _autoLogin();
    if (session != null) {
      final (user, token, isProfileComplete) = session;
      emit(AuthAuthenticated(user: user, token: token, isProfileComplete: isProfileComplete));
    }
  }

  Future<void> completeProfile() async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) return;
    try {
      await _completeProfile(currentState.token);
      emit(AuthAuthenticated(
        user: currentState.user,
        token: currentState.token,
        isProfileComplete: true,
      ));
    } catch (_) {
      // silently ignore — navigation already proceeds to home
    }
  }

  Future<void> logout() async {
    await _logout();
    emit(const AuthInitial());
  }
}
