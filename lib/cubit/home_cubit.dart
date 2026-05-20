import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/location_service.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final LocationService _service;

  HomeCubit(this._service) : super(HomeInitial());

  Future<void> load({String? region}) async {
    emit(HomeLoading());
    try {
      final locations = await _service.getFeatured(region: region);
      emit(HomeLoaded(locations));
    } catch (_) {
      emit(HomeError('Không tải được dữ liệu. Vui lòng thử lại.'));
    }
  }
}
