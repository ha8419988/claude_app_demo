class UserDto {
  final String id;
  final String name;
  final String email;

  const UserDto({required this.id, required this.name, required this.email});

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
      );
}

class AuthResponse {
  final String token;
  final UserDto user;

  const AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        token: json['token'] as String,
        user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      );
}
