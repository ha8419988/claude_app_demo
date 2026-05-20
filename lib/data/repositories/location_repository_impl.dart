import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_remote_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource _remote;
  LocationRepositoryImpl(this._remote);

  @override
  Future<List<Location>> getFeatured({String? region}) =>
      _remote.getFeatured(region: region);
}
