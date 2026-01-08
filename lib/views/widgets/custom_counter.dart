import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';

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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                if (value > 1) {
                  initialValue != null
                      ? cubit.decrement(product.id, initialValue)
                      : cubit.decrement(product.id);
                }
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.remove),
              ),
            ),
            const SizedBox(width: 15),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 15),
            CircleAvatar(
              backgroundColor: Colors.white,
              child: InkWell(
                onTap: () {
                  initialValue != null
                      ? cubit.increment(product.id, initialValue)
                      : cubit.increment(product.id);
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
