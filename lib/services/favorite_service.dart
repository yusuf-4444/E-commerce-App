import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_path.dart';

abstract class FavoriteService {
  Future<void> addToFavorite(String userId, ProductItemModel product);
  Future<void> removeFromFavorite(String userId, ProductItemModel product);
  Future<List<ProductItemModel>> getFavoriteProducts();
}

class FavoriteServiceImpl implements FavoriteService {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;

  @override
  Future<void> addToFavorite(String userId, ProductItemModel product) async {
    final result = await _firestoreServices.setData(
      path: ApiPath.favorite(userId, product.id),
      data: product.toMap(),
    );
    return result;
  }

  @override
  Future<void> removeFromFavorite(
    String userId,
    ProductItemModel product,
  ) async {
    final result = await _firestoreServices.deleteData(
      path: ApiPath.favorite(userId, product.id),
    );
    return result;
  }

  @override
  Future<List<ProductItemModel>> getFavoriteProducts() async {
    final AuthServiceImpl authService = AuthServiceImpl();
    final result = await _firestoreServices.getCollection<ProductItemModel>(
      path: ApiPath.userFavorite(authService.getCurrentUser()!.uid),
      builder: (data, documentId) => ProductItemModel.fromMap(data),
    );
    return result;
  }
}
