import 'package:flutter_ecommerce_app/models/add_location_model.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_path.dart';

abstract class LocationService {
  Future<List<LocationItemModel>> getLocations();

  Future<void> setLocation(LocationItemModel locationItemModel);
}

class LocationServiceImpl implements LocationService {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;
  final AuthServiceImpl _authService = AuthServiceImpl();
  @override
  Future<void> setLocation(LocationItemModel locationItemModel) async {
    final result = await _firestoreServices.setData(
      path: ApiPath.location(
        _authService.getCurrentUser()!.uid,
        locationItemModel.id,
      ),
      data: locationItemModel.toMap(),
    );
    return result;
  }

  @override
  Future<List<LocationItemModel>> getLocations() async {
    final result = await _firestoreServices.getCollection(
      path: ApiPath.locations(_authService.getCurrentUser()!.uid),
      builder: (data, documentId) => LocationItemModel.fromMap(data),
    );
    return result;
  }
}
