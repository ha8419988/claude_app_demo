class LoginRequest {
  final String email;
  final String password;
  const LoginRequest({required this.email, required this.password});
  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String name;
  final String email;
  final String password;
  const RegisterRequest({required this.name, required this.email, required this.password});
  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'password': password};
}

class SocialLoginRequest {
  final String provider;
  final String token;
  const SocialLoginRequest({required this.provider, required this.token});
  Map<String, dynamic> toJson() => {'provider': provider, 'token': token};
}
