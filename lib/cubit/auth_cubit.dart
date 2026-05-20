import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/auto_login_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final AutoLoginUseCase _autoLogin;
  final LogoutUseCase _logout;

  AuthCubit({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required AutoLoginUseCase autoLoginUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _login = loginUseCase,
        _register = registerUseCase,
        _autoLogin = autoLoginUseCase,
        _logout = logoutUseCase,
        super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final (user, token) = await _login(email, password);
      emit(AuthAuthenticated(user: user, token: token));
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

  Future<void> tryAutoLogin() async {
    final session = await _autoLogin();
    if (session != null) {
      final (user, token) = session;
      emit(AuthAuthenticated(user: user, token: token));
    }
  }

  Future<void> logout() async {
    await _logout();
    emit(const AuthInitial());
  }
}
