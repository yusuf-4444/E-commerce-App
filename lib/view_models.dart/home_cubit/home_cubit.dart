import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/home_carosel_item_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/favorite_service.dart';
import 'package:flutter_ecommerce_app/services/home_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final HomeServiceImpl _homeServiceImpl = HomeServiceImpl();
  final AuthService _authService = AuthServiceImpl();
  final FavoriteServiceImpl _favoriteServiceImpl = FavoriteServiceImpl();

  Future<void> getHomeData() async {
    emit(HomeLoading());

    try {
      final products = await _homeServiceImpl.getProductsData();
      final homeCarousel = await _homeServiceImpl.getHomeCarouselData();
      final favoriteProducts = await _favoriteServiceImpl.getFavoriteProducts();

      final List<ProductItemModel> productsWithFavorite = products.map((
        product,
      ) {
        final isFavorite = favoriteProducts.any(
          (element) => element.id == product.id,
        );
        return product.copyWith(isFavorite: isFavorite);
      }).toList();

      emit(
        HomeSuccess(
          homeCarouselItemModel: homeCarousel,
          productItemModel: productsWithFavorite,
        ),
      );
    } catch (e) {
      emit(HomeFaliure(message: e.toString()));
    }
  }

  Future<void> setFavorite(ProductItemModel product) async {
    emit(HomeFavoriteLoading(productID: product.id));
    try {
      final currentUser = _authService.getCurrentUser();
      final favoriteItems = await _favoriteServiceImpl.getFavoriteProducts();
      final isFavorite = favoriteItems.any(
        (element) => element.id == product.id,
      );
      if (isFavorite) {
        await _favoriteServiceImpl.removeFromFavorite(
          currentUser!.uid,
          product,
        );
      } else {
        await _favoriteServiceImpl.addToFavorite(currentUser!.uid, product);
      }
      emit(HomeFavoriteSuccess(isFavorite: isFavorite, product.id));
    } catch (e) {
      emit(HomeFavoriteFaliure(message: e.toString(), product.id));
    }
  }
}
