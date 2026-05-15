import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CurlLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final body = options.data != null ? jsonEncode(options.data) : '';
    final bodyPart = body.isNotEmpty ? " -d '$body'" : '';
    debugPrint("curl -X ${options.method} '${options.uri}' -H 'Content-Type: application/json'$bodyPart");
    handler.next(options);
  }
}
