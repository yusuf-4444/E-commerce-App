import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models.dart/add_card_cubit/add_card_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_text_field.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _cardHolderName = TextEditingController();
  final TextEditingController _expiryDate = TextEditingController();
  final TextEditingController _cvv = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textEditingController.dispose();
    _cardHolderName.dispose();
    _expiryDate.dispose();
    _cvv.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCardCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Add New Card",
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      icon: Icons.credit_card,
                      title: "Card Number",
                      controller: _textEditingController,
                      hintText: "Enter Card Number",
                    ),
                    CustomTextField(
                      icon: Icons.person,
                      title: "Card Holder Name",
                      controller: _cardHolderName,
                      hintText: "Enter Card Holder Name",
                    ),
                    CustomTextField(
                      icon: Icons.date_range,
                      title: "Expiry Date",
                      controller: _expiryDate,
                      hintText: "Enter Expiry Date",
                    ),
                    CustomTextField(
                      icon: Icons.password,
                      title: "CVV",
                      controller: _cvv,
                      hintText: "Enter CVV",
                    ),
                    const Spacer(),
                    BlocConsumer<AddCardCubit, AddCardState>(
                      listener: (context, state) {
                        if (state is AddCardSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Card Added Successfully"),
                            ),
                          );
                          Navigator.pop(context);
                        } else if (state is AddCardError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      buildWhen: (previous, current) =>
                          current is AddCardLoading ||
                          current is AddCardError ||
                          current is AddCardSuccess,
                      builder: (context, state) {
                        if (state is AddCardLoading) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else if (state is AddCardError) {
                          return Center(child: Text(state.message));
                        }
                        return ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AddCardCubit>(context).addCard(
                                _textEditingController.text,
                                _cardHolderName.text,
                                _expiryDate.text,
                                _cvv.text,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.center,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Add Card",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
