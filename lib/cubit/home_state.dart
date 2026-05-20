import '../models/location.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Location> locations;
  HomeLoaded(this.locations);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
