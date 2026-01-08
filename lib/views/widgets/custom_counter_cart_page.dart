import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/view_models.dart/cart_cubit/cart_cubit.dart';

class CustomCounterCartPage extends StatelessWidget {
  const CustomCounterCartPage({
    super.key,
    required this.product,
    required this.cubit,
    required this.value,
    this.initialValue,
    this.id, //this.currentId,
  });

  final ProductItemModel product;
  final dynamic cubit;
  final int value;
  final int? initialValue;
  final String? id;
  // final String? currentId;

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
            BlocBuilder<CartCubit, CartState>(
              bloc: cubit,
              buildWhen: (previous, current) =>
                  current is DecrementLoading ||
                  current is DecrementSuccess ||
                  current is DecrementFailure,
              builder: (context, state) {
                if (state is DecrementLoading && id == state.productId) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is DecrementFailure) {
                  return Center(child: Text(state.message));
                } else if (state is DecrementSuccess) {
                  return InkWell(
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
                  );
                }
                return InkWell(
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
                );
              },
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
            BlocBuilder<CartCubit, CartState>(
              bloc: cubit,
              buildWhen: (previous, current) {
                return current is IncrementLoading ||
                    current is IncrementSuccess ||
                    current is IncrementFailure;
              },
              builder: (context, state) {
                if (state is IncrementFailure) {
                  return Center(child: Text(state.message));
                }
                if (state is IncrementLoading && id == state.productId) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  child: InkWell(
                    onTap: () {
                      initialValue != null
                          ? cubit.increment(product.id, initialValue)
                          : cubit.increment(product.id);
                    },
                    child: const Icon(Icons.add),
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
