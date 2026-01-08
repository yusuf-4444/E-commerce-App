part of 'home_cubit.dart';

class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final List<HomeCarouselItemModel> homeCarouselItemModel;
  final List<ProductItemModel> productItemModel;

  HomeSuccess({
    required this.homeCarouselItemModel,
    required this.productItemModel,
  });
}

final class HomeFaliure extends HomeState {
  final String message;

  HomeFaliure({required this.message});
}

final class HomeFavoriteLoading extends HomeState {
  final String productID;

  HomeFavoriteLoading({required this.productID});
}

final class HomeFavoriteSuccess extends HomeState {
  final bool isFavorite;
  final String productID;

  HomeFavoriteSuccess(this.productID, {required this.isFavorite});
}

final class HomeFavoriteFaliure extends HomeState {
  final String message;
  final String productID;

  HomeFavoriteFaliure(this.productID, {required this.message});
}
