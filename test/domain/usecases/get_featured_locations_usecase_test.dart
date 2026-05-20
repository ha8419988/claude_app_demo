import 'package:claude_app_demo/domain/entities/location.dart';
import 'package:claude_app_demo/domain/repositories/location_repository.dart';
import 'package:claude_app_demo/domain/usecases/get_featured_locations_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  late GetFeaturedLocationsUseCase useCase;
  late MockLocationRepository repository;

  const tLocations = [
    Location(
      id: 1, name: 'Hạ Long', province: 'Quảng Ninh', region: 'north',
      category: 'nature', topic: 'sea', rating: 4.8, featured: true,
      image: 'https://example.com/halong.jpg',
    ),
  ];

  setUp(() {
    repository = MockLocationRepository();
    useCase = GetFeaturedLocationsUseCase(repository);
  });

  test('returns locations from repository', () async {
    when(() => repository.getFeatured(region: any(named: 'region')))
        .thenAnswer((_) async => tLocations);

    final result = await useCase();

    expect(result, equals(tLocations));
    verify(() => repository.getFeatured(region: null)).called(1);
  });

  test('passes region filter to repository', () async {
    when(() => repository.getFeatured(region: 'north'))
        .thenAnswer((_) async => tLocations);

    await useCase(region: 'north');

    verify(() => repository.getFeatured(region: 'north')).called(1);
  });
}
