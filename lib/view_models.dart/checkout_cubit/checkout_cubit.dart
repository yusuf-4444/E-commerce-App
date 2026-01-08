import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_location_model.dart';
import 'package:flutter_ecommerce_app/models/add_new_card.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/cart_service.dart';
import 'package:flutter_ecommerce_app/services/location_service.dart';
import 'package:flutter_ecommerce_app/services/payment_methods_service.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(CheckoutInitial());

  final CartServiceImpl cartServiceImpl = CartServiceImpl();
  final PaymentMethodsServiceImpl _paymentMethodsService =
      PaymentMethodsServiceImpl();
  final LocationServiceImpl _locationServiceImpl = LocationServiceImpl();
  final AuthServiceImpl _authService = AuthServiceImpl();
  final FirestoreServices _firestoreServices = FirestoreServices.instance;

  Future<void> checkout() async {
    emit(CheckoutLoading());
    try {
      final paymentCards = await _paymentMethodsService.getPaymentMethods();
      final cartItems = await cartServiceImpl.getCartItems();

      if (cartItems.isEmpty) {
        emit(CheckoutFaliure("Your cart is empty"));
        return;
      }

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
    } catch (e) {
      emit(CheckoutFaliure(e.toString()));
    }
  }

  Future<void> placeOrder() async {
    if (state is! CheckoutSuccess) {
      emit(PlaceOrderFailure("Invalid checkout state"));
      return;
    }

    final currentState = state as CheckoutSuccess;

    // Validate payment method
    if (currentState.chosenCard == null) {
      emit(PlaceOrderFailure("Please add a payment method"));
      await checkout(); // Reload state
      return;
    }

    // Validate delivery address
    if (currentState.chosenLocation == null) {
      emit(PlaceOrderFailure("Please add a delivery address"));
      await checkout(); // Reload state
      return;
    }

    emit(PlaceOrderLoading());

    try {
      final userId = _authService.getCurrentUser()?.uid;
      if (userId == null) {
        emit(PlaceOrderFailure("User not authenticated"));
        return;
      }

      // Create order data
      final orderData = {
        'userId': userId,
        'products': currentState.products.map((p) => p.toMap()).toList(),
        'totalAmount': currentState.subTotal,
        'numberOfItems': currentState.numberOfItems,
        'paymentMethod': currentState.chosenCard!.toMap(),
        'deliveryAddress': currentState.chosenLocation!.toMap(),
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Save order to Firestore
      await _firestoreServices.setData(
        path: 'orders/${DateTime.now().millisecondsSinceEpoch}',
        data: orderData,
      );

      // Clear cart after successful order
      final cartItems = await cartServiceImpl.getCartItems();
      for (var item in cartItems) {
        await _firestoreServices.deleteData(
          path: 'users/$userId/cart/${item.id}',
        );
      }

      emit(PlaceOrderSuccess());
    } catch (e) {
      emit(PlaceOrderFailure(e.toString()));
      await checkout(); // Reload state after error
    }
  }

  void validateCheckout() {
    if (state is CheckoutSuccess) {
      final currentState = state as CheckoutSuccess;

      List<String> errors = [];

      if (currentState.chosenCard == null) {
        errors.add("Payment method is required");
      }

      if (currentState.chosenLocation == null) {
        errors.add("Delivery address is required");
      }

      if (currentState.products.isEmpty) {
        errors.add("Cart is empty");
      }

      if (errors.isNotEmpty) {
        emit(CheckoutValidationError(errors));
      }
    }
  }
}
