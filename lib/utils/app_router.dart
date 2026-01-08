import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/choose_location_cubit/choose_location_cubit.dart';
import 'package:flutter_ecommerce_app/view_models.dart/prdouct_cubit/product_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/add_new_card_page.dart';
import 'package:flutter_ecommerce_app/views/pages/checkout_page.dart';
import 'package:flutter_ecommerce_app/views/pages/choose_your_location_page.dart';
import 'package:flutter_ecommerce_app/views/pages/custom_navbar.dart';
import 'package:flutter_ecommerce_app/views/pages/login_page.dart';
import 'package:flutter_ecommerce_app/views/pages/product_details_page.dart';
import 'package:flutter_ecommerce_app/views/pages/register_page.dart';

class AppRouter {
  static Route<dynamic> onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.homeRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const CustomNavbar();
          },
        );
      case AppRoutes.checkoutRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const CheckoutPage();
          },
        );
      case AppRoutes.addNewCardRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const AddNewCard();
          },
        );
      case AppRoutes.loginRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const LoginPage();
          },
        );
      case AppRoutes.registerRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return const RegisterPage();
          },
        );
      case AppRoutes.addNewAddressRoute:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return BlocProvider(
              create: (context) => ChooseLocationCubit()..fetchLocation(),
              child: const ChooseYourLocationPage(),
            );
          },
        );
      case AppRoutes.productDetailsRoute:
        final String productDetailsArgs = settings.arguments as String;
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return BlocProvider(
              create: (context) =>
                  ProductCubit()..getProduct(productDetailsArgs),
              child: ProductDetailsPage(productID: productDetailsArgs),
            );
          },
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            return Scaffold(
              body: Text("No Route defined for ${settings.name}"),
            );
          },
        );
    }
  }
}
