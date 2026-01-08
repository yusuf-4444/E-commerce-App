import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/services/auth_service.dart';
import 'package:flutter_ecommerce_app/services/product_details_service.dart';

part 'product_cubit_state.dart';

class ProductCubit extends Cubit<ProductCubitState> {
  ProductCubit() : super(ProductCubitInitial());

  final _productDetailsService = ProductDetailsServiceImpl();
  final authService = AuthServiceImpl();

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
      final cart = AddToCartModel(
        selectedSize: selectedSize!,
        productId: selectedProduct,
        id: DateTime.now().toIso8601String(),
        quantity: quantity,
      );

      final currentUser = authService.getCurrentUser();
      if (currentUser == null) {
        emit(AddToCartFailure("User not authenticated"));
        return;
      }

      await _productDetailsService.addToCart(cart, currentUser.uid);

      emit(AddToCartSuccess(id));

      // Reset after successful add to cart
      Future.delayed(const Duration(seconds: 2), () {
        quantity = 1;
        selectedSize = null;
        emit(ProductCubitSuccess(selectedProduct));
      });
    } catch (e) {
      emit(AddToCartFailure(e.toString()));
    }
  }

  void resetProduct() {
    quantity = 1;
    selectedSize = null;
  }
}
