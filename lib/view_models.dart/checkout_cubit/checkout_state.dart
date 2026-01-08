part of 'checkout_cubit.dart';

class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutSuccess extends CheckoutState {
  final List<AddToCartModel> products;
  final int numberOfItems;
  final double subTotal;
  final AddNewCard? chosenCard;
  final LocationItemModel? chosenLocation;

  CheckoutSuccess({
    required this.numberOfItems,
    required this.products,
    required this.subTotal,
    this.chosenCard,
    this.chosenLocation,
  });
}

final class CheckoutFaliure extends CheckoutState {
  final String message;
  CheckoutFaliure(this.message);
}

// Place Order States
final class PlaceOrderLoading extends CheckoutState {}

final class PlaceOrderSuccess extends CheckoutState {}

final class PlaceOrderFailure extends CheckoutState {
  final String message;
  PlaceOrderFailure(this.message);
}

// Validation State
final class CheckoutValidationError extends CheckoutState {
  final List<String> errors;
  CheckoutValidationError(this.errors);
}
