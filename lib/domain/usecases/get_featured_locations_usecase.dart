import '../entities/location.dart';
import '../repositories/location_repository.dart';

class GetFeaturedLocationsUseCase {
  final LocationRepository _repository;
  const GetFeaturedLocationsUseCase(this._repository);

  Future<List<Location>> call({String? region}) =>
      _repository.getFeatured(region: region);
}
