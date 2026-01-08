import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCounter extends StatelessWidget {
  const CustomCounter({
    super.key,
    required this.product,
    required this.cubit,
    required this.value,
    this.initialValue,
  });

  final ProductItemModel product;
  final dynamic cubit;
  final int value;
  final int? initialValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                if (value > 1) {
                  initialValue != null
                      ? cubit.decrement(product.id, initialValue)
                      : cubit.decrement(product.id);
                }
              },
              child: Container(
                height: 32.h,
                width: 32.w,
                decoration: BoxDecoration(
                  color: value > 1
                      ? Colors.deepPurple.withOpacity(0.1)
                      : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove,
                  color: value > 1 ? Colors.deepPurple : Colors.grey,
                  size: 18.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 16.w),
            GestureDetector(
              onTap: () {
                initialValue != null
                    ? cubit.increment(product.id, initialValue)
                    : cubit.increment(product.id);
              },
              child: Container(
                height: 32.h,
                width: 32.w,
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
                child: Icon(Icons.add, color: Colors.white, size: 18.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
