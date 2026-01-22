import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/product_details_service.dart';
import 'package:flutter_ecommerce_app/services/cart_service.dart';

part 'product_cubit_state.dart';

class ProductCubit extends Cubit<ProductCubitState> {
  ProductCubit() : super(ProductCubitInitial());

  final _productDetailsService = ProductDetailsServiceImpl();
  final authService = AuthServiceImpl();
  final _cartService = CartServiceImpl();

  int quantity = 1;
  ProductSize? selectedSize;

  Future<void> getProduct(String id) async {
    emit(ProductCubitLoading());
    try {
      final product = await _productDetailsService.getProductData(id);
      // Reset quantity and size when loading a new product
      quantity = 1;
      selectedSize = null;
      emit(ProductCubitSuccess(product));
    } catch (e) {
      emit(ProductCubitError(e.toString()));
    }
  }

  void increment(String id) {
    if (quantity < 99) {
      // Add max limit
      quantity++;
      emit(QuantityCounterLoaded(quantity));
    }
  }

  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(Sizeselected(size));
  }

  void decrement(String id) {
    if (quantity > 1) {
      quantity--;
      emit(QuantityCounterLoaded(quantity));
    }
  }

  Future<void> addToCart(String id) async {
    if (selectedSize == null) {
      emit(AddToCartFailure("Please select a size"));
      return;
    }

    emit(AddToCartLoading());

    try {
      final selectedProduct = await _productDetailsService.getProductData(id);
      final currentUser = authService.getCurrentUser();

      if (currentUser == null) {
        emit(AddToCartFailure("User not authenticated"));
        return;
      }

      // Check if product with same size already exists in cart
      final cartItems = await _cartService.getCartItems();
      final existingItemIndex = cartItems.indexWhere(
        (item) =>
            item.productId.id == selectedProduct.id &&
            item.selectedSize == selectedSize,
      );

      if (existingItemIndex != -1) {
        // Product with same size exists, update quantity
        final existingItem = cartItems[existingItemIndex];
        final updatedQuantity = existingItem.quantity + quantity;

        final updatedCart = existingItem.copyWith(
          quantity: updatedQuantity > 99 ? 99 : updatedQuantity,
        );

        await _productDetailsService.addToCart(updatedCart, currentUser.uid);
      } else {
        // Product doesn't exist, add new one
        final uniqueId =
            '${DateTime.now().millisecondsSinceEpoch}_${DateTime.now().microsecond}';

        final cart = AddToCartModel(
          selectedSize: selectedSize!,
          productId: selectedProduct,
          id: uniqueId,
          quantity: quantity,
        );

        await _productDetailsService.addToCart(cart, currentUser.uid);
      }

      emit(AddToCartSuccess(id));

      await Future.delayed(const Duration(seconds: 2));
      quantity = 1;
      selectedSize = null;

      // Re-fetch product to ensure fresh state
      final freshProduct = await _productDetailsService.getProductData(id);
      emit(ProductCubitSuccess(freshProduct));
    } catch (e) {
      emit(AddToCartFailure(e.toString()));
    }
  }

  void resetProduct() {
    quantity = 1;
    selectedSize = null;
  }
}
