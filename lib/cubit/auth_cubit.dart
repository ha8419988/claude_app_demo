import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _service;

  AuthCubit(this._service) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final (user, token) = await _service.login(email, password);
      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(const AuthLoading());
    try {
      final (user, token) = await _service.register(name, email, password);
      emit(AuthAuthenticated(user: user, token: token));
    } catch (e) {
      emit(AuthError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> tryAutoLogin() async {
    final session = await _service.getSavedSession();
    if (session != null) {
      final (user, token) = session;
      emit(AuthAuthenticated(user: user, token: token));
    }
  }

  Future<void> logout() async {
    await _service.clearSession();
    emit(const AuthInitial());
  }
}
