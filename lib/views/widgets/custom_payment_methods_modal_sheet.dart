import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/add_card_cubit/add_card_cubit.dart';

class CustomPaymentMethodsModalSheet extends StatelessWidget {
  const CustomPaymentMethodsModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCardCubit()..getCards(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<AddCardCubit, AddCardState>(
            buildWhen: (previous, current) =>
                current is PaymentMethodsLoading ||
                current is PaymentMethodsSuccess ||
                current is PaymentMethodsError,
            builder: (context, state) {
              if (state is PaymentMethodsError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(child: Text("No payment methods found")),
                    const SizedBox(height: 20),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 0,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AppRoutes.addNewCardRoute)
                                .then(
                                  (value) => BlocProvider.of<AddCardCubit>(
                                    context,
                                  ).getCards(),
                                );
                          },
                          child: Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                "Add new card",
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 18,
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
              if (state is PaymentMethodsLoading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (state is PaymentMethodsSuccess) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose a payment method",
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 25),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.cards.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            elevation: 0,
                            color: Colors.white,
                            child: ListTile(
                              leading: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/MasterCard_Logo.svg/1200px-MasterCard_Logo.svg.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              title: Text(
                                'MasterCard',
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                state.cards[index].cardHolderName,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              trailing: BlocBuilder<AddCardCubit, AddCardState>(
                                buildWhen: (previous, current) =>
                                    current is PaymentMethodSelected,
                                builder: (context, methodState) {
                                  if (methodState is PaymentMethodSelected) {
                                    final chosePaymentMethod = methodState.card;
                                    return Radio<String>(
                                      value: state.cards[index].id,
                                      groupValue: chosePaymentMethod.id,
                                      onChanged: (id) {
                                        BlocProvider.of<AddCardCubit>(
                                          context,
                                        ).paymentMethodSelected(id!);
                                      },
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 0,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.addNewCardRoute)
                                  .then(
                                    (value) => BlocProvider.of<AddCardCubit>(
                                      context,
                                    ).getCards(),
                                  );
                            },
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  child: Icon(
                                    Icons.add,
                                    size: 30,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  "Add new card",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      BlocListener<AddCardCubit, AddCardState>(
                        listener: (context, state) {
                          if (state is ConfirmPaymentSuccess) {
                            Navigator.of(context).pop();
                          }
                        },
                        child: BlocBuilder<AddCardCubit, AddCardState>(
                          buildWhen: (previous, current) =>
                              current is ConfirmPaymentSuccess ||
                              current is ConfirmPaymentLoading ||
                              current is ConfirmPaymentError,
                          builder: (context, state) {
                            if (state is ConfirmPaymentLoading) {
                              return const CircularProgressIndicator.adaptive();
                            }

                            return ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<AddCardCubit>(
                                  context,
                                ).confirmPaymentMethod();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: AppColors.primary,
                                minimumSize: const Size(double.infinity, 50),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                alignment: Alignment.center,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Confirm Payment",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom,
                      ),
                    ],
                  ),
                );
              } else if (state is PaymentMethodsError) {
                return Center(child: Text(state.message));
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
