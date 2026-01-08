import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models.dart/add_card_cubit/add_card_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({super.key});

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  String _formatExpiryDate(String value) {
    value = value.replaceAll('/', '');
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCardCubit(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          title: Text(
            "Add New Card",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card Preview
                      Container(
                        height: 200.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.deepPurple,
                              Colors.deepPurple.withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.credit_card,
                                    color: Colors.white,
                                    size: 40.sp,
                                  ),
                                  Text(
                                    "VISA",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _cardNumberController.text.isEmpty
                                    ? "**** **** **** ****"
                                    : _formatCardNumber(
                                        _cardNumberController.text,
                                      ),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "CARD HOLDER",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      Text(
                                        _cardHolderNameController.text.isEmpty
                                            ? "YOUR NAME"
                                            : _cardHolderNameController.text
                                                  .toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "EXPIRES",
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                      Text(
                                        _expiryDateController.text.isEmpty
                                            ? "MM/YY"
                                            : _expiryDateController.text,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),

                      // Card Number Field
                      CustomTextField(
                        icon: Icons.credit_card,
                        title: "Card Number",
                        controller: _cardNumberController,
                        hintText: "1234 5678 9012 3456",
                      ),

                      // Card Holder Name
                      CustomTextField(
                        icon: Icons.person,
                        title: "Card Holder Name",
                        controller: _cardHolderNameController,
                        hintText: "John Doe",
                      ),

                      // Expiry Date and CVV Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Expiry Date",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                TextFormField(
                                  controller: _expiryDateController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  onChanged: (value) {
                                    if (value.length == 4) {
                                      _expiryDateController.text =
                                          _formatExpiryDate(value);
                                      _expiryDateController.selection =
                                          TextSelection.fromPosition(
                                            TextPosition(
                                              offset: _expiryDateController
                                                  .text
                                                  .length,
                                            ),
                                          );
                                    }
                                    setState(() {});
                                  },
                                  decoration: InputDecoration(
                                    hintText: "MM/YY",
                                    prefixIcon: const Icon(
                                      Icons.calendar_today,
                                      color: Colors.deepPurple,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required";
                                    }
                                    if (value.length < 5) {
                                      return "Invalid";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CVV",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                TextFormField(
                                  controller: _cvvController,
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: "123",
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.deepPurple,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[50],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Required";
                                    }
                                    if (value.length < 3) {
                                      return "Invalid";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),

                      // Submit Button
                      BlocConsumer<AddCardCubit, AddCardState>(
                        listener: (context, state) {
                          if (state is AddCardSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Card Added Successfully"),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          } else if (state is AddCardError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            );
                          }
                        },
                        buildWhen: (previous, current) =>
                            current is AddCardLoading ||
                            current is AddCardError ||
                            current is AddCardSuccess,
                        builder: (context, state) {
                          if (state is AddCardLoading) {
                            return Container(
                              height: 56.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.deepPurple.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<AddCardCubit>(context).addCard(
                                  _cardNumberController.text,
                                  _cardHolderNameController.text,
                                  _expiryDateController.text,
                                  _cvvController.text,
                                );
                              }
                            },
                            child: Container(
                              height: 56.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.deepPurple.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Add Card",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
