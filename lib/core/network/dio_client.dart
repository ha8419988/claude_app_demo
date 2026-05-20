import 'package:dio/dio.dart';

class DioClient {
  // TODO: đổi lại sang Render URL sau khi deploy
  // Android emulator dùng 10.0.2.2 để trỏ về localhost máy tính
  static const _baseUrl = 'http://10.0.2.2:3000/api';

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
