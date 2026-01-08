import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models.dart/prdouct_cubit/product_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/product_details_body.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({super.key, required this.productID});

  final String productID;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProductCubit, ProductCubitState>(
      buildWhen: (previous, current) =>
          current is ProductCubitLoading ||
          current is ProductCubitSuccess ||
          current is ProductCubitError ||
          current is ProductCubitInitial,

      builder: (context, state) {
        if (state is ProductCubitLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (state is ProductCubitSuccess) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text(
                "Product Details",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_outline),
                ),
              ],
            ),
            body: ProductDetailsBody(size: size, product: state.product),
          );
        } else if (state is ProductCubitError) {
          return const Scaffold(body: Center(child: Text("Error")));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
