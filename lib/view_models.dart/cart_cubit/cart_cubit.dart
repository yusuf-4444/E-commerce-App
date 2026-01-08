import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/services/cart_service.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  double totalPrice = 0;

  final CartServiceImpl cartServiceImpl = CartServiceImpl();

  Future<void> fetchCartItems() async {
    emit(CartLoading());
    try {
      final cartItems = await cartServiceImpl.getCartItems();
      double totalPrice = cartItems.fold(
        0,
        (previousValue, element) =>
            previousValue + element.productId.price * element.quantity,
      );
      emit(CartSuccess(cartItems, totalPrice));
    } catch (e) {
      emit(CartFaliure(e.toString()));
    }
  }

  Future<void> decrement(String id, [int? initialValue]) async {
    try {
      emit(DecrementLoading(id));

      final cartItems = await cartServiceImpl.getCartItems();
      final index = cartItems.indexWhere(
        (element) => element.productId.id == id,
      );
      if (index == -1) {
        emit(CartFaliure("Product not found in cart"));
        return;
      }
      final cartItem = cartItems[index];

      int currentQuantity = initialValue ?? cartItem.quantity;
      currentQuantity--;
      double currentPrice = cartItem.productId.price * currentQuantity;

      final updatedCartItem = cartItem.copyWith(quantity: currentQuantity);
      cartItems[index] = updatedCartItem;

      cartServiceImpl.decreaseQuantity(updatedCartItem);

      emit(QuantityCounterLoaded(currentQuantity, id, currentPrice));
      double totalPrice = cartItems.fold(
        0,
        (previousValue, element) =>
            previousValue + element.productId.price * element.quantity,
      );
      emit(SubTotalUpdated(totalPrice));
      emit(DecrementSuccess());
    } catch (e) {
      emit(CartFaliure("Error updating quantity: ${e.toString()}"));
      emit(DecrementFailure(e.toString()));
    }
  }

  Future<void> increment(String productId, [int? initialValue]) async {
    try {
      emit(IncrementLoading(productId));

      final cartItems = await cartServiceImpl.getCartItems();
      final index = cartItems.indexWhere(
        (element) => element.productId.id == productId,
      );

      if (index == -1) {
        emit(CartFaliure("Product not found in cart"));
        return;
      }

      final cartItem = cartItems[index];
      int currentQuantity = initialValue ?? cartItem.quantity;
      currentQuantity++;

      double currentPrice = cartItem.productId.price * currentQuantity;

      final updatedCartItem = cartItem.copyWith(quantity: currentQuantity);
      cartItems[index] = updatedCartItem;

      await cartServiceImpl.increaseQuantity(updatedCartItem);

      emit(QuantityCounterLoaded(currentQuantity, productId, currentPrice));
      double totalPrice = cartItems.fold(
        0,
        (previousValue, element) =>
            previousValue + element.productId.price * element.quantity,
      );
      emit(SubTotalUpdated(totalPrice));
      emit(IncrementSuccess());
    } catch (e) {
      emit(CartFaliure("Error updating quantity: ${e.toString()}"));
      emit(IncrementFailure(e.toString()));
    }
  }
}
