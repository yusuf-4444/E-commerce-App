import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_location_model.dart';
import 'package:flutter_ecommerce_app/models/add_new_card.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/services/cart_service.dart';
import 'package:flutter_ecommerce_app/services/location_service.dart';
import 'package:flutter_ecommerce_app/services/payment_methods_service.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final CartServiceImpl cartServiceImpl = CartServiceImpl();
  final PaymentMethodsServiceImpl _paymentMethodsService =
      PaymentMethodsServiceImpl();
  final LocationServiceImpl _locationServiceImpl = LocationServiceImpl();

  Future<void> checkout() async {
    emit(CheckoutLoading());
    final paymentCards = await _paymentMethodsService.getPaymentMethods();
    final cartItems = await cartServiceImpl.getCartItems();
    final products = cartItems;
    double totalPrice = cartItems.fold(
      0,
      (previousValue, element) =>
          previousValue + element.productId.price * element.quantity,
    );
    int numberOfItems = cartItems.fold(
      0,
      (previousValue, element) => previousValue + element.quantity,
    );
    final AddNewCard? chosenCard = paymentCards.isNotEmpty
        ? paymentCards.firstWhere(
            (card) => card.isSelected,
            orElse: () => paymentCards.first,
          )
        : null;
    final locations = await _locationServiceImpl.getLocations();
    if (locations.isEmpty) {
      emit(
        CheckoutSuccess(
          numberOfItems: numberOfItems,
          products: products,
          subTotal: totalPrice + 10,
          chosenCard: chosenCard,
          chosenLocation: null,
        ),
      );
    } else {
      final chosenLocation = locations.firstWhere(
        (location) => location.isChosen,
        orElse: () => locations.first,
      );
      emit(
        CheckoutSuccess(
          numberOfItems: numberOfItems,
          products: products,
          subTotal: totalPrice + 10,
          chosenCard: chosenCard,
          chosenLocation: chosenLocation,
        ),
      );
    }
  }
}
