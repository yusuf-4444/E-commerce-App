import 'package:flutter_ecommerce_app/models/add_new_card.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_path.dart';

abstract class PaymentMethodsService {
  Future<List<AddNewCard>> getPaymentMethods();
  Future<void> setPaymentMethod(AddNewCard card);
}

class PaymentMethodsServiceImpl implements PaymentMethodsService {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;
  final AuthServiceImpl _authService = AuthServiceImpl();

  @override
  Future<List<AddNewCard>> getPaymentMethods() async {
    final result = await _firestoreServices.getCollection(
      path: ApiPath.paymentMethods(_authService.getCurrentUser()!.uid),
      builder: (data, documentId) => AddNewCard.fromMap(data),
    );
    return result;
  }

  @override
  Future<void> setPaymentMethod(AddNewCard card) {
    return _firestoreServices.setData(
      path: ApiPath.paymentMethod(_authService.getCurrentUser()!.uid, card.id),
      data: card.toMap(),
    );
  }
}
