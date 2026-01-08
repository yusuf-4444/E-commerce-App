import 'package:flutter_ecommerce_app/models/category_model.dart';
import 'package:flutter_ecommerce_app/models/home_carosel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_path.dart';

abstract class HomeService {
  Future<List<ProductItemModel>> getProductsData();
  Future<List<CategoryModel>> getCategoriesData();
  Future<List<HomeCarouselItemModel>> getHomeCarouselData();
}

class HomeServiceImpl implements HomeService {
  final FirestoreServices _firestoreServices = FirestoreServices.instance;
  @override
  Future<List<ProductItemModel>> getProductsData() async {
    final result = await _firestoreServices.getCollection(
      path: ApiPath.products(),
      builder: (data, documentId) => ProductItemModel.fromMap(data),
    );
    return result;
  }

  @override
  Future<List<CategoryModel>> getCategoriesData() async {
    final result = await _firestoreServices.getCollection(
      path: ApiPath.categories(),
      builder: (data, documentId) => CategoryModel.fromMap(data),
    );
    return result;
  }

  @override
  Future<List<HomeCarouselItemModel>> getHomeCarouselData() async {
    final result = await _firestoreServices.getCollection(
      path: ApiPath.homeCarousel(),
      builder: (data, documentId) => HomeCarouselItemModel.fromMap(data),
    );
    return result;
  }
}
