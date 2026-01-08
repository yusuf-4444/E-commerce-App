import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart'
    show FirestoreServices;
import 'package:flutter_ecommerce_app/utils/api_path.dart';

abstract class CartService {
  Future<List<AddToCartModel>> getCartItems();
  Future<void> increaseQuantity(AddToCartModel cart);
  Future<void> decreaseQuantity(AddToCartModel cart);
}

class CartServiceImpl implements CartService {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;
  final AuthServiceImpl _authService = AuthServiceImpl();
  @override
  Future<List<AddToCartModel>> getCartItems() async {
    final result = await _firestoreServices.getCollection(
      path: ApiPath.userCart(_authService.getCurrentUser()!.uid),
      builder: (data, documentId) => AddToCartModel.fromMap(data),
    );
    return result;
  }

  @override
  Future<void> decreaseQuantity(AddToCartModel cart) async {
    final result = await _firestoreServices.setData(
      path: ApiPath.addToCart(_authService.getCurrentUser()!.uid, cart.id),
      data: cart.toMap(),
    );
    return result;
  }

  @override
  Future<void> increaseQuantity(AddToCartModel cart) async {
    final result = await _firestoreServices.setData(
      path: ApiPath.addToCart(_authService.getCurrentUser()!.uid, cart.id),
      data: cart.toMap(),
    );
    return result;
  }
}
