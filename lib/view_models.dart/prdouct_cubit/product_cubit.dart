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
      emit(ProductCubitSuccess(product));
    } catch (e) {
      emit(ProductCubitError(e.toString()));
    }
    /* Future.delayed((const Duration(seconds: 2)), () {
      final product = dummyProducts.firstWhere((element) => element.id == id);
      emit(ProductCubitSuccess(product));
    });*/
  }

  void increment(String id) {
    quantity++;
    emit(QuantityCounterLoaded(quantity));
  }

  void selectSize(ProductSize size) {
    selectedSize = size;
    emit(Sizeselected(size));
  }

  void decrement(String id) {
    quantity--;
    emit(
      quantity > 0 ? QuantityCounterLoaded(quantity) : QuantityCounterLoaded(0),
    );
  }

  Future<void> addToCart(String id) async {
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
      await _productDetailsService.addToCart(cart, currentUser!.uid);

      emit(AddToCartSuccess(id));
    } catch (e) {
      emit(AddToCartFailure(e.toString()));
      print(e.toString());
    }

    /*final cartItem = AddToCartModel(
      selectedSize: selectedSize!,
      id: DateTime.now().toString(),
      quantity: quantity,
      productId: dummyProducts.firstWhere((element) => element.id == id),
    );
    cartItems.add(cartItem);

    Future.delayed(const Duration(seconds: 2), () {
      emit(AddToCartSuccess(id));
    });
    */
  }
}

List<AddToCartModel> cartItems = [];
