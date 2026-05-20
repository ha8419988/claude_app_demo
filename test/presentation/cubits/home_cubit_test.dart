import 'package:bloc_test/bloc_test.dart';
import 'package:claude_app_demo/cubit/home_cubit.dart';
import 'package:claude_app_demo/cubit/home_state.dart';
import 'package:claude_app_demo/domain/entities/location.dart';
import 'package:claude_app_demo/domain/usecases/get_featured_locations_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetFeaturedLocationsUseCase extends Mock
    implements GetFeaturedLocationsUseCase {}

void main() {
  late HomeCubit cubit;
  late MockGetFeaturedLocationsUseCase useCase;

  const tLocations = [
    Location(
      id: 1, name: 'Hạ Long', province: 'Quảng Ninh', region: 'north',
      category: 'nature', topic: 'sea', rating: 4.8,
      featured: true, image: 'https://example.com/halong.jpg',
    ),
  ];

  setUp(() {
    useCase = MockGetFeaturedLocationsUseCase();
    cubit = HomeCubit(useCase);
  });

  tearDown(() => cubit.close());

  blocTest<HomeCubit, HomeState>(
    'emits [HomeLoading, HomeLoaded] on success',
    build: () {
      when(() => useCase(region: any(named: 'region')))
          .thenAnswer((_) async => tLocations);
      return cubit;
    },
    act: (c) => c.load(),
    expect: () => [HomeLoading(), HomeLoaded(tLocations)],
  );

  blocTest<HomeCubit, HomeState>(
    'emits [HomeLoading, HomeError] on failure',
    build: () {
      when(() => useCase(region: any(named: 'region')))
          .thenThrow(Exception('network error'));
      return cubit;
    },
    act: (c) => c.load(),
    expect: () => [
      HomeLoading(),
      HomeError('Không tải được dữ liệu. Vui lòng thử lại.'),
    ],
  );

  blocTest<HomeCubit, HomeState>(
    'passes region filter to use case',
    build: () {
      when(() => useCase(region: 'north'))
          .thenAnswer((_) async => tLocations);
      return cubit;
    },
    act: (c) => c.load(region: 'north'),
    verify: (_) => verify(() => useCase(region: 'north')).called(1),
    expect: () => [HomeLoading(), HomeLoaded(tLocations)],
  );
}
