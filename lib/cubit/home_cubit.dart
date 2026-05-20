import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/usecases/get_featured_locations_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetFeaturedLocationsUseCase _getLocations;

  HomeCubit(this._getLocations) : super(HomeInitial());

  Future<void> load({String? region}) async {
    emit(HomeLoading());
    try {
      final locations = await _getLocations(region: region);
      emit(HomeLoaded(locations));
    } catch (_) {
      emit(HomeError('Không tải được dữ liệu. Vui lòng thử lại.'));
    }
  }
}
