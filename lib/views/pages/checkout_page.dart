import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_location_model.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/checkout_cubit/checkout_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_payment_card.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_payment_methods_modal_sheet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit()..checkout(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          title: Text(
            "Checkout",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) {
            return BlocBuilder<CheckoutCubit, CheckoutState>(
              bloc: BlocProvider.of<CheckoutCubit>(context),
              buildWhen: (previous, current) {
                return current is CheckoutLoading ||
                    current is CheckoutFaliure ||
                    current is CheckoutSuccess;
              },
              builder: (context, state) {
                if (state is CheckoutLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  );
                } else if (state is CheckoutFaliure) {
                  return Center(child: Text(state.message));
                } else if (state is CheckoutSuccess) {
                  final chosenCard = state.chosenCard;
                  final chosenLocation = state.chosenLocation;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Delivery Address Section
                        _buildSection(
                          context,
                          "Delivery Address",
                          onEdit: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushNamed(AppRoutes.addNewAddressRoute)
                                .then(
                                  (value) => BlocProvider.of<CheckoutCubit>(
                                    context,
                                  ).checkout(),
                                );
                          },
                          child: chosenLocation != null
                              ? _buildAddressCard(context, chosenLocation)
                              : _buildEmptyCard(
                                  context,
                                  "Add Delivery Address",
                                  Icons.add_location_alt,
                                  () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(AppRoutes.addNewAddressRoute)
                                        .then(
                                          (value) =>
                                              BlocProvider.of<CheckoutCubit>(
                                                context,
                                              ).checkout(),
                                        );
                                  },
                                ),
                        ),

                        // Payment Method Section
                        _buildSection(
                          context,
                          "Payment Method",
                          onEdit: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (sheetContext) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(24.r),
                                    ),
                                  ),
                                  child: BlocProvider.value(
                                    value: BlocProvider.of<CheckoutCubit>(
                                      context,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 24.h,
                                      ),
                                      child:
                                          const CustomPaymentMethodsModalSheet(),
                                    ),
                                  ),
                                );
                              },
                            ).then(
                              (value) => BlocProvider.of<CheckoutCubit>(
                                context,
                              ).checkout(),
                            );
                          },
                          child: chosenCard != null
                              ? CustomPaymentCard(
                                  card: chosenCard,
                                  onTap: () {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (sheetContext) {
                                        return Container(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.7,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(24.r),
                                            ),
                                          ),
                                          child: BlocProvider.value(
                                            value:
                                                BlocProvider.of<CheckoutCubit>(
                                                  context,
                                                ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 24.h,
                                              ),
                                              child:
                                                  const CustomPaymentMethodsModalSheet(),
                                            ),
                                          ),
                                        );
                                      },
                                    ).then(
                                      (value) => BlocProvider.of<CheckoutCubit>(
                                        context,
                                      ).checkout(),
                                    );
                                  },
                                )
                              : _buildEmptyCard(
                                  context,
                                  "Add Payment Method",
                                  Icons.payment,
                                  () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pushNamed(AppRoutes.addNewCardRoute)
                                        .then(
                                          (value) =>
                                              BlocProvider.of<CheckoutCubit>(
                                                context,
                                              ).checkout(),
                                        );
                                  },
                                ),
                        ),

                        // Order Summary Section
                        _buildSection(
                          context,
                          "Order Summary (${state.numberOfItems} items)",
                          child: Column(
                            children: List.generate(state.products.length, (
                              index,
                            ) {
                              final product = state.products[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 12.h),
                                padding: EdgeInsets.all(12.r),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 80.h,
                                      width: 80.w,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: product.productId.imgUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.productId.name,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "Size: ${product.selectedSize!.name} • Qty: ${product.quantity}",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "\$${(product.productId.price * product.quantity).toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),

                        SizedBox(height: 100.h),
                      ],
                    ),
                  );
                }
                return const Center(child: Text("Something went wrong"));
              },
            );
          },
        ),
        bottomSheet: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutSuccess) {
              return Container(
                padding: EdgeInsets.all(20.r),
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
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Total Amount",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "\$${state.subTotal.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Place order logic
                          },
                          child: Container(
                            height: 56.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.deepPurple,
                                  Colors.deepPurple.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.deepPurple.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Place Order",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title, {
    VoidCallback? onEdit,
    required Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (onEdit != null)
                TextButton(
                  onPressed: onEdit,
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, LocationItemModel location) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: location.imgUrl,
              height: 80.h,
              width: 80.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.city,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "${location.city}, ${location.country}",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey[300]!, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, size: 48.sp, color: Colors.deepPurple),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
