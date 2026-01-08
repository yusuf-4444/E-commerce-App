import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/view_models.dart/cart_cubit/cart_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCounterCartPage extends StatelessWidget {
  const CustomCounterCartPage({
    super.key,
    required this.product,
    required this.cubit,
    required this.value,
    this.initialValue,
    this.id,
  });

  final ProductItemModel product;
  final dynamic cubit;
  final int value;
  final int? initialValue;
  final String? id;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Decrement Button
            BlocBuilder<CartCubit, CartState>(
              bloc: cubit,
              buildWhen: (previous, current) =>
                  current is DecrementLoading ||
                  current is DecrementSuccess ||
                  current is DecrementFailure,
              builder: (context, state) {
                if (state is DecrementLoading && id == state.productId) {
                  return SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    if (value > 1) {
                      initialValue != null
                          ? cubit.decrement(product.id, initialValue)
                          : cubit.decrement(product.id);
                    }
                  },
                  child: Container(
                    height: 28.h,
                    width: 28.w,
                    decoration: BoxDecoration(
                      color: value > 1
                          ? Colors.deepPurple.withOpacity(0.1)
                          : Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.remove,
                      color: value > 1 ? Colors.deepPurple : Colors.grey[600],
                      size: 16.sp,
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 12.w),

            // Counter Value
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 12.w),

            // Increment Button
            BlocBuilder<CartCubit, CartState>(
              bloc: cubit,
              buildWhen: (previous, current) =>
                  current is IncrementLoading ||
                  current is IncrementSuccess ||
                  current is IncrementFailure,
              builder: (context, state) {
                if (state is IncrementLoading && id == state.productId) {
                  return SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    initialValue != null
                        ? cubit.increment(product.id, initialValue)
                        : cubit.increment(product.id);
                  },
                  child: Container(
                    height: 28.h,
                    width: 28.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple,
                          Colors.deepPurple.withOpacity(0.8),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 16.sp),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
