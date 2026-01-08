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

  List<ProductItemModel> _cachedProducts = [];
  List<HomeCarouselItemModel> _cachedCarousel = [];

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

      _cachedProducts = productsWithFavorite;
      _cachedCarousel = homeCarousel;

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
      if (currentUser == null) {
        emit(
          HomeFavoriteFaliure(message: "User not authenticated", product.id),
        );
        return;
      }

      final favoriteItems = await _favoriteServiceImpl.getFavoriteProducts();
      final isFavorite = favoriteItems.any(
        (element) => element.id == product.id,
      );

      if (isFavorite) {
        await _favoriteServiceImpl.removeFromFavorite(currentUser.uid, product);
      } else {
        await _favoriteServiceImpl.addToFavorite(currentUser.uid, product);
      }

      // Update cached products
      _cachedProducts = _cachedProducts.map((p) {
        if (p.id == product.id) {
          return p.copyWith(isFavorite: !isFavorite);
        }
        return p;
      }).toList();

      emit(HomeFavoriteSuccess(product.id, isFavorite: isFavorite));

      // Emit updated home state with new favorite status
      emit(
        HomeSuccess(
          homeCarouselItemModel: _cachedCarousel,
          productItemModel: _cachedProducts,
        ),
      );
    } catch (e) {
      emit(HomeFavoriteFaliure(message: e.toString(), product.id));

      // Restore previous state
      if (_cachedProducts.isNotEmpty) {
        emit(
          HomeSuccess(
            homeCarouselItemModel: _cachedCarousel,
            productItemModel: _cachedProducts,
          ),
        );
      }
    }
  }

  Future<void> refreshHome() async {
    await getHomeData();
  }

  void clearCache() {
    _cachedProducts = [];
    _cachedCarousel = [];
  }
}
