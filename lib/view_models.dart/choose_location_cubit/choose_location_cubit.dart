import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_location_model.dart';
import 'package:flutter_ecommerce_app/services/location_service.dart';

part 'choose_location_state.dart';

class ChooseLocationCubit extends Cubit<ChooseLocationState> {
  ChooseLocationCubit() : super(FetchLocationInitial());

  final LocationServiceImpl _locationServiceImpl = LocationServiceImpl();

  String? location;

  Future<void> fetchLocation() async {
    emit(FetchLocationLoading());
    try {
      final locations = await _locationServiceImpl.getLocations();
      location = locations
          .firstWhere(
            (element) => element.isChosen,
            orElse: () => locations.first,
          )
          .id;
      emit(FetchLocationSuccess(locations));
    } catch (e) {
      emit(FetchLocationFaliure(e.toString()));
    }
  }

  Future<void> setLocation(String location) async {
    emit(AddLocationLoading());
    try {
      final splittedLocation = location.split("-");
      final newLocation = LocationItemModel(
        id: DateTime.now().toIso8601String(),
        city: splittedLocation[0],
        country: splittedLocation[1],
      );
      await _locationServiceImpl.setLocation(newLocation);
      emit(AddLocationSuccess());
      final locations = await _locationServiceImpl.getLocations();
      emit(FetchLocationSuccess(locations));
    } catch (e) {
      emit(AddLocationFaliure(e.toString()));
    }
  }

  Future<void> chooseLocation(String id) async {
    final locations = await _locationServiceImpl.getLocations();
    location = id;
    final updatedLocations = locations.map((loc) {
      return loc.copyWith(isChosen: loc.id == id);
    }).toList();
    emit(FetchLocationSuccess(updatedLocations));
  }

  Future<void> confirmLocation() async {
    emit(ConfirmLocationLoading());
    final locations = await _locationServiceImpl.getLocations();

    var chosenLocation = locations.firstWhere(
      (element) => element.id == location,
      orElse: () => locations.first,
    );
    var previousLocation = locations.firstWhere(
      (element) => element.isChosen,
      orElse: () => locations.first,
    );
    previousLocation = previousLocation.copyWith(isChosen: false);
    chosenLocation = chosenLocation.copyWith(isChosen: true);

    await _locationServiceImpl.setLocation(chosenLocation);
    await _locationServiceImpl.setLocation(previousLocation);

    emit(ChoosenLocation(chosenLocation));
    emit(FetchLocationSuccess(locations));
    emit(ConfirmLocationSuccess());
  }
}
