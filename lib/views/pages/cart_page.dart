import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_counter_cart_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CartCubit>(context).fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: BlocConsumer<CartCubit, CartState>(
          bloc: BlocProvider.of<CartCubit>(context),
          listenWhen: (previous, current) =>
              current is DeleteFromCartSuccess ||
              current is DeleteFromCartFailure,
          listener: (context, state) {
            if (state is DeleteFromCartSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Item removed from cart"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            } else if (state is DeleteFromCartFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            }
          },
          buildWhen: (previous, current) {
            return current is CartLoading ||
                current is CartFaliure ||
                current is CartSuccess;
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              );
            } else if (state is CartFaliure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 100.sp,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is CartSuccess) {
              if (state.cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100.sp,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Your cart is empty",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Add items to get started",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<CartCubit>(context).fetchCartItems();
                      },
                      color: Colors.deepPurple,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.r),
                        itemCount: state.cartItems.length,
                        itemBuilder: (context, index) {
                          return CustomCartItemWidget(
                            cartItem: state.cartItems[index],
                            onDelete: () {
                              _showDeleteDialog(
                                context,
                                state.cartItems[index],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  // Summary Section
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          children: [
                            BlocBuilder<CartCubit, CartState>(
                              buildWhen: (previous, current) =>
                                  current is CartSuccess ||
                                  current is SubTotalUpdated,
                              builder: (context, subTotalState) {
                                final subtotal =
                                    subTotalState is SubTotalUpdated
                                    ? subTotalState.subTotal
                                    : state.totalPrice;

                                return Column(
                                  children: [
                                    _buildPriceRow(
                                      context,
                                      "Subtotal",
                                      "\$${subtotal.toStringAsFixed(2)}",
                                    ),
                                    SizedBox(height: 12.h),
                                    _buildPriceRow(
                                      context,
                                      "Shipping",
                                      "\$10.00",
                                    ),
                                    SizedBox(height: 16.h),
                                    Divider(color: Colors.grey[300]),
                                    SizedBox(height: 16.h),
                                    _buildPriceRow(
                                      context,
                                      "Total",
                                      "\$${(subtotal + 10).toStringAsFixed(2)}",
                                      isTotal: true,
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 20.h),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamed(AppRoutes.checkoutRoute);
                              },
                              child: Container(
                                height: 56.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      AppColors.primary.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Proceed to Checkout",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AddToCartModel cartItem) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          "Remove Item",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to remove ${cartItem.productId.name} from your cart?",
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              BlocProvider.of<CartCubit>(context).deleteFromCart(cartItem.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    String label,
    String price, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 16.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 24.sp : 16.sp,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.deepPurple : Colors.black87,
          ),
        ),
      ],
    );
  }
}

class CustomCartItemWidget extends StatelessWidget {
  const CustomCartItemWidget({
    super.key,
    required this.cartItem,
    required this.onDelete,
  });

  final AddToCartModel cartItem;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(cartItem.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: const Text("Remove Item"),
            content: Text(
              "Are you sure you want to remove ${cartItem.productId.name}?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Remove"),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        BlocProvider.of<CartCubit>(context).deleteFromCart(cartItem.id);
      },
      background: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20.r),
        ),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete_outline, color: Colors.white, size: 32.sp),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: cartItem.productId.imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          cartItem.productId.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onDelete,
                        child: Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Size: ${cartItem.selectedSize!.name}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  BlocBuilder<CartCubit, CartState>(
                    buildWhen: (previous, current) =>
                        current is CartSuccess ||
                        current is QuantityCounterLoaded &&
                            current.id == cartItem.productId.id,
                    builder: (context, state) {
                      final quantity = state is QuantityCounterLoaded
                          ? state.value
                          : cartItem.quantity;
                      final price = state is QuantityCounterLoaded
                          ? state.price
                          : cartItem.productId.price * cartItem.quantity;

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomCounterCartPage(
                            id: cartItem.productId.id,
                            product: cartItem.productId,
                            cubit: BlocProvider.of<CartCubit>(context),
                            value: quantity,
                            initialValue: cartItem.quantity,
                          ),
                          Text(
                            "\$${price.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
