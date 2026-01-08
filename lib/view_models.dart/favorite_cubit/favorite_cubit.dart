import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/favorite_service.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final FavoriteServiceImpl _favoriteServiceImpl = FavoriteServiceImpl();

  Future<void> getFavorites() async {
    emit(FavoriteLoading());
    try {
      final favoriteItems = await _favoriteServiceImpl.getFavoriteProducts();
      emit(FavoriteSuccess(favoriteProducts: favoriteItems));
    } catch (e) {
      emit(FavoriteFaliure(message: e.toString()));
    }
  }

  Future<void> removeFavorites(ProductItemModel product) async {
    emit(FavoriteDeleteLoading());
    try {
      final AuthServiceImpl authService = AuthServiceImpl();
      await _favoriteServiceImpl.removeFromFavorite(
        authService.getCurrentUser()!.uid,
        product,
      );
      final favoriteItems = await _favoriteServiceImpl.getFavoriteProducts();
      emit(FavoriteDeleteSuccess());
      emit(FavoriteSuccess(favoriteProducts: favoriteItems));
    } catch (e) {
      emit(FavoriteDeleteFaliure(message: e.toString()));
    }
  }
}
