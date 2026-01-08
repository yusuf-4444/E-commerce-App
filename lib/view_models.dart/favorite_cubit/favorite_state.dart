part of 'favorite_cubit.dart';

class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteSuccess extends FavoriteState {
  final List<ProductItemModel> favoriteProducts;
  FavoriteSuccess({required this.favoriteProducts});
}

final class FavoriteFaliure extends FavoriteState {
  final String message;
  FavoriteFaliure({required this.message});
}

final class FavoriteDeleteLoading extends FavoriteState {}

final class FavoriteDeleteSuccess extends FavoriteState {}

final class FavoriteDeleteFaliure extends FavoriteState {
  final String message;
  FavoriteDeleteFaliure({required this.message});
}
