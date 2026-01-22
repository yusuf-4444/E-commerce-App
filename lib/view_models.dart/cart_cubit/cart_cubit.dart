import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/services/cart_service.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/firestore_services.dart';
import 'package:flutter_ecommerce_app/utils/api_path.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  double totalPrice = 0;

  final CartServiceImpl cartServiceImpl = CartServiceImpl();
  final AuthServiceImpl _authService = AuthServiceImpl();
  final FirestoreServices _firestoreServices = FirestoreServices.instance;

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

  Future<void> deleteFromCart(String cartItemId) async {
    try {
      emit(DeleteFromCartLoading());

      final userId = _authService.getCurrentUser()?.uid;
      if (userId == null) {
        emit(DeleteFromCartFailure("User not authenticated"));
        return;
      }

      await _firestoreServices.deleteData(
        path: ApiPath.addToCart(userId, cartItemId),
      );

      emit(DeleteFromCartSuccess());

      // Refresh cart items after deletion
      await fetchCartItems();
    } catch (e) {
      emit(DeleteFromCartFailure(e.toString()));
    }
  }

  Future<void> decrement(String id, [int? initialValue]) async {
    try {
      final cartItems = await cartServiceImpl.getCartItems();
      final index = cartItems.indexWhere(
        (element) => element.productId.id == id,
      );

      if (index == -1) {
        emit(CartFaliure("Product not found in cart"));
        return;
      }

      final cartItem = cartItems[index];
      int currentQuantity = cartItem.quantity;

      // If quantity is 1, delete the item instead of decrementing
      if (currentQuantity <= 1) {
        await deleteFromCart(cartItem.id);
        return;
      }

      emit(DecrementLoading(id));

      currentQuantity--;
      double currentPrice = cartItem.productId.price * currentQuantity;

      final updatedCartItem = cartItem.copyWith(quantity: currentQuantity);
      cartItems[index] = updatedCartItem;

      await cartServiceImpl.decreaseQuantity(updatedCartItem);

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
      int currentQuantity = cartItem.quantity;

      // Add max limit
      if (currentQuantity >= 99) {
        emit(IncrementFailure("Maximum quantity reached"));
        return;
      }

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

  Future<void> clearCart() async {
    try {
      emit(ClearCartLoading());

      final userId = _authService.getCurrentUser()?.uid;
      if (userId == null) {
        emit(ClearCartFailure("User not authenticated"));
        return;
      }

      final cartItems = await cartServiceImpl.getCartItems();

      for (var item in cartItems) {
        await _firestoreServices.deleteData(
          path: ApiPath.addToCart(userId, item.id),
        );
      }

      emit(ClearCartSuccess());
      await fetchCartItems();
    } catch (e) {
      emit(ClearCartFailure(e.toString()));
    }
  }
}
