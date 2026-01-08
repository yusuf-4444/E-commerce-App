import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_ecommerce_app/models/add_to_cart_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_counter_cart_page.dart';

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
        body: BlocBuilder<CartCubit, CartState>(
          bloc: BlocProvider.of<CartCubit>(context),
          buildWhen: (previous, current) {
            return current is CartLoading ||
                current is CartFaliure ||
                current is CartSuccess;
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state is CartFaliure) {
              return Center(child: Text(state.message));
            } else if (state is CartSuccess) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 25),
                    RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<CartCubit>(context).fetchCartItems();
                      },
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.cartItems.length,
                        itemBuilder: (context, index) {
                          return CustomCartItemWidget(
                            cartItems: state.cartItems,
                            index: index,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: BlocBuilder<CartCubit, CartState>(
                        buildWhen: (previous, current) =>
                            current is CartSuccess ||
                            current is SubTotalUpdated,
                        builder: (context, subTotalState) {
                          if (subTotalState is SubTotalUpdated) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Subtotal",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      "\$${subTotalState.subTotal}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Shipping",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      "\$10",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Dash(
                                  length:
                                      MediaQuery.of(context).size.width * 0.9,
                                  dashColor: Colors.grey,
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      "\$${subTotalState.subTotal + 10}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Subtotal",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    "\$${state.totalPrice}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Shipping",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    "\$10",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 25),
                              Dash(
                                length: MediaQuery.of(context).size.width * 0.9,
                                dashColor: Colors.grey,
                              ),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Total",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    "\$${state.totalPrice + 10}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushNamed(AppRoutes.checkoutRoute);
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text(
                            "Checkout",
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class CustomCartItemWidget extends StatelessWidget {
  const CustomCartItemWidget({
    super.key,
    required this.cartItems,
    required this.index,
  });
  final List<AddToCartModel> cartItems;
  final int index;
  @override
  Widget build(BuildContext context) {
    final cartItem = cartItems[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: SizedBox(
        height: 150,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: CachedNetworkImage(imageUrl: cartItem.productId.imgUrl),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.productId.name,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: "Size:"),
                      TextSpan(
                        text: " ${cartItem.selectedSize!.name}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                BlocBuilder<CartCubit, CartState>(
                  buildWhen: (previous, current) =>
                      current is CartSuccess ||
                      current is QuantityCounterLoaded &&
                          current.id == cartItem.productId.id,
                  builder: (context, state) {
                    if (state is CartSuccess) {
                      return Row(
                        children: [
                          CustomCounterCartPage(
                            id: cartItem.productId.id,
                            product: cartItem.productId,
                            cubit: BlocProvider.of<CartCubit>(context),
                            value: cartItem.quantity,
                            initialValue: cartItem.quantity,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "\$${cartItem.productId.price * cartItem.quantity}",
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green,
                                ),
                          ),
                        ],
                      );
                    } else if (state is QuantityCounterLoaded) {
                      return Row(
                        children: [
                          CustomCounterCartPage(
                            id: cartItem.productId.id,
                            product: cartItem.productId,
                            cubit: BlocProvider.of<CartCubit>(context),
                            value: state.value,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "\$${state.price}",
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green,
                                ),
                          ),
                        ],
                      );
                    }
                    return Row(
                      children: [
                        CustomCounterCartPage(
                          id: cartItem.productId.id,
                          product: cartItem.productId,
                          cubit: BlocProvider.of<CartCubit>(context),
                          value: cartItem.quantity,
                          initialValue: cartItem.quantity,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "\$${cartItem.productId.price * cartItem.quantity}",
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                fontWeight: FontWeight.w900,
                                color: Colors.green,
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
