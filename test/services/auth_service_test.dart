import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:claude_app_demo/data/remote/auth_api.dart';
import 'package:claude_app_demo/data/remote/dto/auth_request.dart';
import 'package:claude_app_demo/data/remote/dto/auth_response.dart';
import 'package:claude_app_demo/services/auth_service.dart';

class MockAuthApi extends Mock implements AuthApi {}

void main() {
  late MockAuthApi mockApi;

  setUpAll(() {
    registerFallbackValue(const LoginRequest(email: '', password: ''));
    registerFallbackValue(const RegisterRequest(name: '', email: '', password: ''));
  });

  setUp(() {
    mockApi = MockAuthApi();
    SharedPreferences.setMockInitialValues({});
  });

  AuthResponse mockResp(String token, String id, String name, String email) =>
      AuthResponse(token: token, user: UserDto(id: id, name: name, email: email));

  DioException dioError(Map<String, dynamic> data, int statusCode) => DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: data,
          statusCode: statusCode,
          requestOptions: RequestOptions(path: ''),
        ),
        type: DioExceptionType.badResponse,
      );

  group('AuthService.login', () {
    test('returns User and token on success', () async {
      when(() => mockApi.login(any()))
          .thenAnswer((_) async => mockResp('jwt123', '1', 'Test', 'test@test.com'));
      final service = AuthService(mockApi);

      final (user, token) = await service.login('test@test.com', '123456');

      expect(user.id, '1');
      expect(user.name, 'Test');
      expect(token, 'jwt123');
    });

    test('throws Exception on 401', () async {
      when(() => mockApi.login(any()))
          .thenThrow(dioError({'error': 'Email hoặc mật khẩu không đúng'}, 401));
      final service = AuthService(mockApi);

      expect(() => service.login('wrong@test.com', 'wrong'), throwsA(isA<Exception>()));
    });
  });

  group('AuthService.register', () {
    test('returns User and token on success', () async {
      when(() => mockApi.register(any()))
          .thenAnswer((_) async => mockResp('jwt456', '2', 'New User', 'new@test.com'));
      final service = AuthService(mockApi);

      final (user, token) = await service.register('New User', 'new@test.com', '123456');

      expect(user.email, 'new@test.com');
      expect(token, 'jwt456');
    });

    test('throws Exception on 409', () async {
      when(() => mockApi.register(any()))
          .thenThrow(dioError({'error': 'Email đã được sử dụng'}, 409));
      final service = AuthService(mockApi);

      expect(() => service.register('User', 'exists@test.com', '123456'), throwsA(isA<Exception>()));
    });
  });

  group('AuthService session', () {
    test('getSavedSession returns null when empty', () async {
      final service = AuthService(mockApi);
      expect(await service.getSavedSession(), isNull);
    });

    test('getSavedSession returns saved user and token after login', () async {
      when(() => mockApi.login(any()))
          .thenAnswer((_) async => mockResp('saved_token', '3', 'Saved', 'saved@test.com'));
      final service = AuthService(mockApi);
      await service.login('saved@test.com', '123456');

      final session = await service.getSavedSession();
      expect(session, isNotNull);
      final (user, token) = session!;
      expect(token, 'saved_token');
      expect(user.email, 'saved@test.com');
    });

    test('clearSession removes saved data', () async {
      SharedPreferences.setMockInitialValues({
        'auth_token': 'old_token',
        'auth_user': jsonEncode({'id': '1', 'name': 'X', 'email': 'x@x.com'}),
      });
      final service = AuthService(mockApi);
      await service.clearSession();
      expect(await service.getSavedSession(), isNull);
    });
  });
}
