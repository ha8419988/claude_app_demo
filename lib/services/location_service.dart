import 'package:dio/dio.dart';
import '../models/location.dart';

class LocationService {
  final Dio _dio;

  LocationService(this._dio);

  Future<List<Location>> getFeatured({String? region}) async {
    try {
      final params = <String, String>{'featured': 'true'};
      if (region != null) params['region'] = region;
      final resp = await _dio.get('/locations', queryParameters: params);
      return (resp.data as List)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['error'] != null) {
        throw Exception(data['error'] as String);
      }
      throw Exception('Không kết nối được server. Vui lòng kiểm tra lại.');
    }
  }
}
