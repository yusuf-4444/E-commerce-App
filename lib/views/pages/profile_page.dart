import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: BlocConsumer<AuthCubit, AuthState>(
            bloc: cubit,
            listenWhen: (previous, current) =>
                current is LogoutSuccess || current is AuthInitial,
            listener: (context, state) {
              if (state is LogoutSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.loginRoute,
                  (route) => false,
                );
              }
            },
            buildWhen: (previous, current) =>
                current is LogoutLoading || current is LogoutSuccess,
            builder: (context, state) {
              if (state is LogoutLoading) {
                return const CircularProgressIndicator.adaptive();
              }

              return CustomButton(
                title: "Logout",
                onTap: () async {
                  await cubit.logout();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
