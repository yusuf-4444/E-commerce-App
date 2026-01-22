import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/constants/assets.dart';
import 'package:flutter_ecommerce_app/view_models.dart/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/view_models.dart/favorite_cubit/favorite_cubit.dart';
import 'package:flutter_ecommerce_app/view_models.dart/home_cubit/home_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/cart_page.dart';
import 'package:flutter_ecommerce_app/views/pages/favorites_page.dart';
import 'package:flutter_ecommerce_app/views/pages/home_page.dart';
import 'package:flutter_ecommerce_app/views/pages/profile_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  int index = 0;
  late CartCubit _cartCubit;

  @override
  void initState() {
    super.initState();
    _cartCubit = CartCubit();
  }

  @override
  void dispose() {
    _cartCubit.close();
    super.dispose();
  }

  void _onTabChanged(int newIndex) {
    setState(() => index = newIndex);

    // Refresh cart when switching to cart tab
    if (newIndex == 1) {
      _cartCubit.fetchCartItems();
    }

    // Refresh favorites when switching to favorites tab
    if (newIndex == 2) {
      BlocProvider.of<FavoriteCubit>(context).getFavorites();
    }

    // Refresh home when switching to home tab
    if (newIndex == 0) {
      BlocProvider.of<HomeCubit>(context).refreshHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.grey.withOpacity(0.1),
        toolbarHeight: 70.h,
        leading: Padding(
          padding: EdgeInsets.all(8.r),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.deepPurple.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 24.r,
              backgroundImage: const AssetImage(
                Assets.assetsImagesUserProfilePNGFreeImage,
              ),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Yusuf Mohamed",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Let's Go Shopping!",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          if (index == 0) ...[
            _buildIconButton(Icons.search_rounded),
            _buildIconButton(Icons.notifications_outlined),
          ] else if (index == 1)
            _buildIconButton(Icons.shopping_cart_outlined),
          SizedBox(width: 8.w),
        ],
      ),
      body: PersistentTabView(
        onTabChanged: _onTabChanged,
        stateManagement: true,
        tabs: [
          PersistentTabConfig(
            screen: const HomePage(),
            item: ItemConfig(
              icon: Icon(CupertinoIcons.home, size: 24.sp),
              title: "Home",
              activeForegroundColor: Colors.deepPurple,
              inactiveForegroundColor: Colors.grey.shade600,
            ),
          ),
          PersistentTabConfig(
            screen: BlocProvider.value(
              value: _cartCubit,
              child: const CartPage(),
            ),
            item: ItemConfig(
              icon: Icon(CupertinoIcons.cart, size: 24.sp),
              title: "Cart",
              activeForegroundColor: Colors.deepPurple,
              inactiveForegroundColor: Colors.grey.shade600,
            ),
          ),
          PersistentTabConfig(
            screen: const FavoritesPage(),
            item: ItemConfig(
              icon: Icon(Icons.favorite_outline, size: 24.sp),
              title: "Favorites",
              activeForegroundColor: Colors.deepPurple,
              inactiveForegroundColor: Colors.grey.shade600,
            ),
          ),
          PersistentTabConfig(
            screen: const ProfilePage(),
            item: ItemConfig(
              icon: Icon(CupertinoIcons.person, size: 24.sp),
              title: "Profile",
              activeForegroundColor: Colors.deepPurple,
              inactiveForegroundColor: Colors.grey.shade600,
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style6BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {},
        icon: Icon(icon, color: Colors.black87, size: 22.sp),
        padding: EdgeInsets.all(8.r),
      ),
    );
  }
}
