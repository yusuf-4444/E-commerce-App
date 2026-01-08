part of 'choose_location_cubit.dart';

class ChooseLocationState {}

final class FetchLocationInitial extends ChooseLocationState {}

final class FetchLocationLoading extends ChooseLocationState {}

final class FetchLocationSuccess extends ChooseLocationState {
  final List<LocationItemModel> locations;
  FetchLocationSuccess(this.locations);
}

final class FetchLocationFaliure extends ChooseLocationState {
  final String message;
  FetchLocationFaliure(this.message);
}

final class AddLocationLoading extends ChooseLocationState {}

final class AddLocationSuccess extends ChooseLocationState {}

final class AddLocationFaliure extends ChooseLocationState {
  final String message;
  AddLocationFaliure(this.message);
}

final class ChoosenLocation extends ChooseLocationState {
  final LocationItemModel location;
  ChoosenLocation(this.location);
}

final class ConfirmLocationLoading extends ChooseLocationState {}

final class ConfirmLocationSuccess extends ChooseLocationState {}

final class ConfirmLocationFaliure extends ChooseLocationState {
  final String message;
  ConfirmLocationFaliure(this.message);
}
