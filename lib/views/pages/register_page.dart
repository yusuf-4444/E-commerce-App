import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/login_page.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_button.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isObsecure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Create Account",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Start shopping with create your account!",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    title: "username",
                    controller: _usernameController,
                    hintText: "Enter your username",
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 30),
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

                  const SizedBox(height: 30),
                  BlocConsumer<AuthCubit, AuthState>(
                    bloc: cubit,
                    listenWhen: (previous, current) =>
                        current is AuthSuccess || current is AuthFailure,
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        Navigator.pushNamed(context, AppRoutes.homeRoute);
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is AuthLoading || current is AuthSuccess,
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return CustomButton(
                        title: "Create Account",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await cubit.registerWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text,
                              _usernameController.text,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "You have an account? Login",
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
                              child: CustomSocialMediaButton(
                                color: Colors.blue,
                                title: 'Signup with Facebook',
                                icon: Icons.facebook,
                                onTap: () {},
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
                              child: CustomSocialMediaButton(
                                title: 'Signup with Google',
                                icon: Icons.g_mobiledata_rounded,
                                color: Colors.red,
                                onTap: () {},
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
