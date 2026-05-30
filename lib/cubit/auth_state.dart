import '../domain/entities/user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
  @override
  bool operator ==(Object other) => other is AuthInitial;
  @override
  int get hashCode => runtimeType.hashCode;
}

class AuthLoading extends AuthState {
  const AuthLoading();
  @override
  bool operator ==(Object other) => other is AuthLoading;
  @override
  int get hashCode => runtimeType.hashCode;
}

class AuthAuthenticated extends AuthState {
  final User user;
  final String token;
  final bool isNewUser;
  final bool isProfileComplete;
  const AuthAuthenticated({
    required this.user,
    required this.token,
    this.isNewUser = false,
    this.isProfileComplete = false,
  });
  @override
  bool operator ==(Object other) =>
      other is AuthAuthenticated &&
      other.user == user &&
      other.token == token &&
      other.isNewUser == isNewUser &&
      other.isProfileComplete == isProfileComplete;
  @override
  int get hashCode => user.hashCode ^ token.hashCode ^ isNewUser.hashCode ^ isProfileComplete.hashCode;
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  bool operator ==(Object other) =>
      other is AuthError && other.message == message;
  @override
  int get hashCode => message.hashCode;
}
