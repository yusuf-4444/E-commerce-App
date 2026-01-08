import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models.dart/prdouct_cubit/product_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_counter.dart';

class ProductDetailsBody extends StatelessWidget {
  const ProductDetailsBody({
    super.key,
    required this.size,
    required this.product,
  });

  final Size size;
  final ProductItemModel product;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.shade300),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.15),
                CachedNetworkImage(
                  imageUrl: product.imgUrl,
                  height: size.height * 0.3,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: size.height * 0.55,
              width: size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.headlineSmall!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.star, color: AppColors.yellow),
                                Text(
                                  " ${product.averageRate}",
                                  style: Theme.of(context).textTheme.titleLarge!
                                      .copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        BlocBuilder<ProductCubit, ProductCubitState>(
                          buildWhen: (previous, current) =>
                              current is QuantityCounterLoaded ||
                              current is ProductCubitSuccess,
                          builder: (context, state) {
                            if (state is QuantityCounterLoaded) {
                              return CustomCounter(
                                value: state.value,
                                product: product,
                                cubit: BlocProvider.of<ProductCubit>(context),
                              );
                            } else if (state is ProductCubitSuccess) {
                              return CustomCounter(
                                product: product,
                                cubit: BlocProvider.of<ProductCubit>(context),
                                value: 1,
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Size",
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    BlocBuilder<ProductCubit, ProductCubitState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: ProductSize.values
                              .map(
                                (size) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      BlocProvider.of<ProductCubit>(
                                        context,
                                      ).selectSize(size);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            state is Sizeselected &&
                                                state.size == size
                                            ? AppColors.primary
                                            : Colors.grey.shade300,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          size.name.toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                color:
                                                    state is Sizeselected &&
                                                        state.size == size
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.headlineSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product.description,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            text: "\$",
                            style: Theme.of(context).textTheme.headlineSmall!
                                .copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w900,
                                ),
                            children: [
                              TextSpan(
                                text: "${product.price}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        BlocBuilder<ProductCubit, ProductCubitState>(
                          builder: (context, state) {
                            if (state is AddToCartLoading) {
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 15,
                                  ),
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: null,
                                label: const CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.add_shopping_cart_outlined,
                                ),
                              );
                            } else if (state is AddToCartSuccess) {
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 15,
                                  ),
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: null,
                                label: const Text("Added"),
                                icon: const Icon(Icons.check),
                              );
                            } else {
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 25,
                                    vertical: 15,
                                  ),
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  if (BlocProvider.of<ProductCubit>(
                                        context,
                                      ).selectedSize ==
                                      null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please select a size"),
                                      ),
                                    );
                                    return;
                                  }
                                  BlocProvider.of<ProductCubit>(
                                    context,
                                  ).addToCart(product.id);
                                },
                                label: const Text("Add to Cart"),
                                icon: const Icon(
                                  Icons.add_shopping_cart_outlined,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
