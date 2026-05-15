import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'dto/auth_request.dart';
import 'dto/auth_response.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest body);

  @POST('/auth/register')
  Future<AuthResponse> register(@Body() RegisterRequest body);
}
