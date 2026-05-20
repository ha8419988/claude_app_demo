import '../entities/location.dart';

abstract class LocationRepository {
  /// Throws [AppException] on failure.
  Future<List<Location>> getFeatured({String? region});
}
