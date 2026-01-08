import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/auth_cubit/auth_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_button.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isObsecure = true;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    // Animated Welcome Section
                    Hero(
                      tag: 'welcome',
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome Back! 👋",
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Sign in to continue your shopping journey",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50.h),
                    CustomTextField(
                      title: "Email",
                      controller: _emailController,
                      hintText: "Enter your email",
                      icon: Icons.email_outlined,
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      obscureText: isObsecure,
                      title: "Password",
                      controller: _passwordController,
                      hintText: "Enter your password",
                      icon: Icons.lock_outline,
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            isObsecure = !isObsecure;
                          });
                        },
                        icon: Icon(
                          isObsecure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
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
                          current is AuthLoading ||
                          current is AuthSuccess ||
                          current is AuthFailure,
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.deepPurple,
                              ),
                            ),
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
                    SizedBox(height: 20.h),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.registerRoute);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                            ),
                            children: const [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    _buildSocialButtons(cubit),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons(AuthCubit cubit) {
    return Column(
      children: [
        BlocConsumer<AuthCubit, AuthState>(
          bloc: cubit,
          listenWhen: (previous, current) =>
              current is AuthenticateWithFacebookSuccess ||
              current is AuthenticateWithFacebookFailure,
          listener: (context, state) {
            if (state is AuthenticateWithFacebookSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeRoute,
                (route) => false,
              );
            } else if (state is AuthenticateWithFacebookFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is AuthenticateWithFacebookLoading ||
              current is AuthenticateWithFacebookSuccess ||
              current is AuthenticateWithFacebookFailure,
          builder: (context, state) {
            if (state is AuthenticateWithFacebookLoading) {
              return _buildLoadingSocialButton(Icons.facebook, Colors.blue);
            }
            return _buildSocialButton(
              icon: Icons.facebook,
              color: Colors.blue,
              label: 'Continue with Facebook',
              onTap: () => cubit.authenticateWithFacebook(),
            );
          },
        ),
        SizedBox(height: 16.h),
        BlocConsumer<AuthCubit, AuthState>(
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
            } else if (state is AuthenticateWithGoogleFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is AuthenticateWithGoogleLoading ||
              current is AuthenticateWithGoogleSuccess ||
              current is AuthenticateWithGoogleFailure,
          builder: (context, state) {
            if (state is AuthenticateWithGoogleLoading) {
              return _buildLoadingSocialButton(
                Icons.g_mobiledata_rounded,
                Colors.red,
              );
            }
            return _buildSocialButton(
              icon: Icons.g_mobiledata_rounded,
              color: Colors.red,
              label: 'Continue with Google',
              onTap: () => cubit.authenticateWithGoogle(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 28.sp),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSocialButton(IconData icon, Color color) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      child: Center(
        child: SizedBox(
          height: 24.h,
          width: 24.w,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ),
    );
  }
}
