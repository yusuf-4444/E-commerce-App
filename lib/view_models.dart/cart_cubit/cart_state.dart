part of 'cart_cubit.dart';

class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartSuccess extends CartState {
  final List<AddToCartModel> cartItems;
  final double totalPrice;
  CartSuccess(this.cartItems, this.totalPrice);
}

final class CartFaliure extends CartState {
  final String message;
  CartFaliure(this.message);
}

final class QuantityCounterLoaded extends CartState {
  final int value;
  final String id;
  final double price;
  QuantityCounterLoaded(this.value, this.id, this.price);
}

final class SubTotalUpdated extends CartState {
  final double subTotal;
  SubTotalUpdated(this.subTotal);
}

final class IncrementLoading extends CartState {
  final String productId;
  IncrementLoading(this.productId);
}

final class IncrementSuccess extends CartState {}

final class IncrementFailure extends CartState {
  final String message;
  IncrementFailure(this.message);
}

final class DecrementLoading extends CartState {
  final String productId;
  DecrementLoading(this.productId);
}

final class DecrementSuccess extends CartState {}

final class DecrementFailure extends CartState {
  final String message;
  DecrementFailure(this.message);
}
