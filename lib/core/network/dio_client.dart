import 'package:dio/dio.dart';

class DioClient {
  static const _baseUrl = 'https://vietnam-explore-api.onrender.com/api';

  static Dio create() {
    final dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));
    // dio.interceptors.add(CurlLogInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  }
}
