import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_path.dart';

abstract class ProductDetailsService {
  Future<ProductItemModel> getProductData(String id);
  Future<void> addToCart(AddToCartModel cart, String userID);
}

class ProductDetailsServiceImpl extends ProductDetailsService {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;
  @override
  Future<ProductItemModel> getProductData(String id) async {
    final result = await _firestoreServices.getDocument<ProductItemModel>(
      path: ApiPath.product(id),
      builder: (data, documentId) => ProductItemModel.fromMap(data),
    );
    return result;
  }

  @override
  Future<void> addToCart(AddToCartModel cart, String userID) async {
    final result = await _firestoreServices.setData(
      path: ApiPath.addToCart(userID, cart.id),
      data: cart.toMap(),
    );
    return result;
  }
}
