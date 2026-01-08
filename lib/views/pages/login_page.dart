import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_button.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObsecure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Login Account",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Please, Login with Registered Account",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    title: "Email",
                    controller: _emailController,
                    hintText: "Enter your email",
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 30),
                  CustomTextField(
                    obscureText: isObsecure,
                    title: "Password",
                    controller: _passwordController,
                    hintText: "Enter your password",
                    icon: Icons.password,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          isObsecure = !isObsecure;
                        });
                      },
                      icon: Icon(
                        isObsecure ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        "Forget Password",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: cubit,
                    listenWhen: (previous, current) =>
                        current is AuthSuccess || current is AuthFailure,
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.homeRoute,
                          (route) => false,
                        );
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is AuthLoading ||
                        current is AuthSuccess ||
                        current is AuthFailure,
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      } else if (state is AuthFailure) {
                        return CustomButton(
                          title: "Login",
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              await cubit.loginWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                              );
                            }
                          },
                        );
                      }
                      return CustomButton(
                        title: "Login",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await cubit.loginWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.registerRoute,
                            );
                          },
                          child: Text(
                            "Don't have an account? Register",
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: Colors.grey.shade600),
                          ),
                        ),
                        Text(
                          "Or Using other method",
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 70,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: BlocConsumer<AuthCubit, AuthState>(
                                bloc: cubit,
                                listenWhen: (previous, current) =>
                                    current
                                        is AuthenticateWithFacebookSuccess ||
                                    current is AuthenticateWithFacebookFailure,
                                listener: (context, state) {
                                  if (state
                                      is AuthenticateWithFacebookSuccess) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.homeRoute,
                                      (route) => false,
                                    );
                                  } else if (state
                                      is AuthenticateWithFacebookFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  }
                                },
                                buildWhen: (previous, current) =>
                                    current
                                        is AuthenticateWithFacebookLoading ||
                                    current
                                        is AuthenticateWithFacebookSuccess ||
                                    current is AuthenticateWithFacebookFailure,
                                builder: (context, state) {
                                  if (state
                                      is AuthenticateWithFacebookLoading) {
                                    return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    );
                                  } else if (state
                                      is AuthenticateWithFacebookFailure) {
                                    return CustomSocialMediaButton(
                                      color: Colors.blue,
                                      title: 'Login with Facebook',
                                      icon: Icons.facebook,
                                      onTap: () {
                                        cubit.authenticateWithFacebook();
                                      },
                                    );
                                  }

                                  return CustomSocialMediaButton(
                                    color: Colors.blue,
                                    title: 'Login with Facebook',
                                    icon: Icons.facebook,
                                    onTap: () {
                                      cubit.authenticateWithFacebook();
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 70,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: BlocConsumer<AuthCubit, AuthState>(
                                bloc: cubit,
                                listenWhen: (previous, current) =>
                                    current is AuthenticateWithGoogleSuccess ||
                                    current is AuthenticateWithGoogleFailure,
                                listener: (context, state) {
                                  if (state is AuthenticateWithGoogleSuccess) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.homeRoute,
                                      (route) => false,
                                    );
                                  } else if (state
                                      is AuthenticateWithGoogleFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                    debugPrint(state.message);
                                  }
                                },
                                buildWhen: (previous, current) =>
                                    current is AuthenticateWithGoogleLoading ||
                                    current is AuthenticateWithGoogleSuccess ||
                                    current is AuthenticateWithGoogleFailure,
                                builder: (context, state) {
                                  if (state is AuthenticateWithGoogleLoading) {
                                    return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    );
                                  }
                                  return CustomSocialMediaButton(
                                    title: 'Login with Google',
                                    icon: Icons.g_mobiledata_rounded,
                                    color: Colors.red,
                                    onTap: () {
                                      cubit.authenticateWithGoogle();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSocialMediaButton extends StatelessWidget {
  const CustomSocialMediaButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 10),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
