part of 'product_cubit.dart';

class ProductCubitState {}

final class ProductCubitInitial extends ProductCubitState {}

final class ProductCubitLoading extends ProductCubitState {}

final class ProductCubitSuccess extends ProductCubitState {
  final ProductItemModel product;
  ProductCubitSuccess(this.product);
}

final class ProductCubitError extends ProductCubitState {
  final String message;
  ProductCubitError(this.message);
}

final class QuantityCounterLoaded extends ProductCubitState {
  final int value;
  QuantityCounterLoaded(this.value);
}

final class Sizeselected extends ProductCubitState {
  final ProductSize size;
  Sizeselected(this.size);
}

final class AddToCartLoading extends ProductCubitState {}

final class AddToCartSuccess extends ProductCubitState {
  final String id;
  AddToCartSuccess(this.id);
}

final class AddToCartFailure extends ProductCubitState {
  final String message;
  AddToCartFailure(this.message);
}
