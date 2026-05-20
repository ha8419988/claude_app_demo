import '../domain/entities/location.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {
  @override
  bool operator ==(Object other) => other is HomeInitial;
  @override
  int get hashCode => runtimeType.hashCode;
}

class HomeLoading extends HomeState {
  @override
  bool operator ==(Object other) => other is HomeLoading;
  @override
  int get hashCode => runtimeType.hashCode;
}

class HomeLoaded extends HomeState {
  final List<Location> locations;
  HomeLoaded(this.locations);
  @override
  bool operator ==(Object other) =>
      other is HomeLoaded && other.locations == locations;
  @override
  int get hashCode => locations.hashCode;
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
  @override
  bool operator ==(Object other) =>
      other is HomeError && other.message == message;
  @override
  int get hashCode => message.hashCode;
}
