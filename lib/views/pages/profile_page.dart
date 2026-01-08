import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/constants/assets.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/auth_cubit/auth_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.deepPurple,
                    Colors.deepPurple.withOpacity(0.8),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50.r,
                          backgroundImage: const AssetImage(
                            Assets.assetsImagesUserProfilePNGFreeImage,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "Yusuf Mohamed",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "yusuf@example.com",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Profile Options
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  _buildProfileSection(context, "Account Settings", [
                    _buildProfileItem(
                      icon: Icons.person_outline,
                      title: "Edit Profile",
                      subtitle: "Update your personal information",
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: Icons.location_on_outlined,
                      title: "Addresses",
                      subtitle: "Manage delivery addresses",
                      onTap: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed(AppRoutes.addNewAddressRoute);
                      },
                    ),
                    _buildProfileItem(
                      icon: Icons.payment_outlined,
                      title: "Payment Methods",
                      subtitle: "Manage your payment cards",
                      onTap: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed(AppRoutes.addNewCardRoute);
                      },
                    ),
                  ]),
                  SizedBox(height: 16.h),
                  _buildProfileSection(context, "Orders", [
                    _buildProfileItem(
                      icon: Icons.shopping_bag_outlined,
                      title: "My Orders",
                      subtitle: "Track your orders",
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: Icons.local_shipping_outlined,
                      title: "Track Order",
                      subtitle: "Real-time order tracking",
                      onTap: () {},
                    ),
                  ]),
                  SizedBox(height: 16.h),
                  _buildProfileSection(context, "Preferences", [
                    _buildProfileItem(
                      icon: Icons.notifications_outlined,
                      title: "Notifications",
                      subtitle: "Manage notification settings",
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: Icons.language_outlined,
                      title: "Language",
                      subtitle: "English (US)",
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: Icons.dark_mode_outlined,
                      title: "Dark Mode",
                      subtitle: "Switch theme",
                      onTap: () {},
                    ),
                  ]),
                  SizedBox(height: 16.h),
                  _buildProfileSection(context, "Support", [
                    _buildProfileItem(
                      icon: Icons.help_outline,
                      title: "Help Center",
                      subtitle: "Get support",
                      onTap: () {},
                    ),
                    _buildProfileItem(
                      icon: Icons.info_outline,
                      title: "About",
                      subtitle: "App version 1.0.0",
                      onTap: () {},
                    ),
                  ]),
                  SizedBox(height: 30.h),

                  // Logout Button
                  BlocConsumer<AuthCubit, AuthState>(
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
                        return Container(
                          height: 56.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.red,
                              ),
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                        onTap: () async {
                          await cubit.logout();
                        },
                        child: Container(
                          height: 56.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 24.sp,
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: Colors.deepPurple, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }
}
