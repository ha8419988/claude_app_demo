import 'package:dio/dio.dart';
import '../../core/error/app_exception.dart';
import '../models/location_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<LocationModel>> getFeatured({String? region});
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final Dio _dio;
  LocationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<LocationModel>> getFeatured({String? region}) async {
    try {
      final params = <String, String>{'featured': 'true'};
      if (region != null) params['region'] = region;
      final resp = await _dio.get('/locations', queryParameters: params);
      return (resp.data as List)
          .map((e) => LocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['error'] != null) {
        throw AppException(data['error'] as String);
      }
      throw const AppException('Không kết nối được server. Vui lòng kiểm tra lại.');
    }
  }
}
