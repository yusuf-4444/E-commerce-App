import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_location_model.dart';
import 'package:flutter_ecommerce_app/models/add_new_card.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/checkout_cubit/checkout_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/checkout_headline_items.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_payment_card.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_payment_methods_modal_sheet.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit()..checkout(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Checkout",
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
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
                    child: CircularProgressIndicator.adaptive(),
                  );
                } else if (state is CheckoutFaliure) {
                  return Center(child: Text(state.message));
                } else if (state is CheckoutSuccess) {
                  final chosenCard = state.chosenCard;
                  final chosenLocation = state.chosenLocation;
                  Widget buildPaymentMethod(AddNewCard? chosenCard) {
                    if (chosenCard != null) {
                      return CustomPaymentCard(
                        card: chosenCard,
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,

                            builder: (sheetContext) {
                              return BlocProvider.value(
                                value: BlocProvider.of<CheckoutCubit>(context),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  width: double.infinity,
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 30,
                                    ),
                                    child: CustomPaymentMethodsModalSheet(),
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
                      );
                    }
                    return InkWell(
                      onTap: () {
                        final cubit = BlocProvider.of<CheckoutCubit>(context);
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed(AppRoutes.addNewCardRoute).then((context) {
                          cubit.checkout();
                        });
                      },
                      child: const CustomEmptyShippingAndPayment(
                        title: "Add Payment Method",
                      ),
                    );
                  }

                  Widget buildShippingAddress(LocationItemModel? location) {
                    if (location != null) {
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: CachedNetworkImage(
                              imageUrl: location.imgUrl,
                              height: 130,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                location.city,
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${location.city}, ${location.country}",
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade400,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return const CustomEmptyShippingAndPayment(
                      title: "Add Shipping Address",
                    );
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CheckoutHeadlineItems(
                            title: "Address",
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(AppRoutes.addNewAddressRoute)
                                  .then(
                                    (value) => BlocProvider.of<CheckoutCubit>(
                                      context,
                                    ).checkout(),
                                  );
                            },
                          ),
                          const SizedBox(height: 15),
                          InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed(AppRoutes.addNewAddressRoute)
                                  .then(
                                    (value) => BlocProvider.of<CheckoutCubit>(
                                      context,
                                    ).checkout(),
                                  );
                            },
                            child: buildShippingAddress(chosenLocation),
                          ),
                          const SizedBox(height: 15),
                          CheckoutHeadlineItems(
                            title: "Products",
                            numOfProducts: state.numberOfItems,
                          ),
                          const SizedBox(height: 10),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final product = state.products[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 8.0,
                                  top: 8.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: product.productId.imgUrl,
                                        height: 50,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.productId.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Size: ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: product.selectedSize!.name
                                                    .toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Quantity: ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: product.quantity
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      "\$${state.products[index].productId.price * state.products[index].quantity}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 25,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                                  return Divider(
                                    thickness: 2,
                                    color: Colors.grey.shade300,
                                    height: 10,
                                    endIndent: 5,
                                    indent: 5,
                                  );
                                },
                          ),

                          const CheckoutHeadlineItems(title: "Payment Methods"),
                          const SizedBox(height: 15),
                          buildPaymentMethod(chosenCard),
                          const SizedBox(height: 15),
                          Divider(
                            thickness: 2,
                            color: Colors.grey.shade200,
                            endIndent: 5,
                            indent: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "Total Amount: ",
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const Spacer(),
                                Text(
                                  "\$${state.subTotal}",
                                  style: Theme.of(context).textTheme.titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 25,
                                        color: Colors.deepPurple,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(double.infinity, 50),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.center,
                              ),
                              child: Text(
                                "Proceed To Buy",
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: Text("Something went wrong"));
              },
            );
          },
        ),
      ),
    );
  }
}

class CustomEmptyShippingAndPayment extends StatelessWidget {
  const CustomEmptyShippingAndPayment({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.add,
              size: 40,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
