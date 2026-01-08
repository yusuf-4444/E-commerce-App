import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/constants/assets.dart';
import 'package:flutter_ecommerce_app/view_models.dart/cart_cubit/cart_cubit.dart';
import 'package:flutter_ecommerce_app/views/pages/cart_page.dart';
import 'package:flutter_ecommerce_app/views/pages/favorites_page.dart';
import 'package:flutter_ecommerce_app/views/pages/home_page.dart';
import 'package:flutter_ecommerce_app/views/pages/profile_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({super.key});

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(
              Assets.assetsImagesUserProfilePNGFreeImage,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Yusuf Mohamed",
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "Let's Go Shopping!",
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          if (index == 0) ...[
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          ] else if (index == 1)
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PersistentTabView(
        onTabChanged: (value) => setState(() => index = value),
        stateManagement: true,
        tabs: [
          PersistentTabConfig(
            screen: const HomePage(),
            item: ItemConfig(
              icon: const Icon(CupertinoIcons.home),
              title: "Home",
            ),
          ),
          PersistentTabConfig(
            screen: BlocProvider(
              create: (context) => CartCubit()..fetchCartItems(),
              child: const CartPage(),
            ),
            item: ItemConfig(
              icon: const Icon(CupertinoIcons.cart),
              title: "Cart",
            ),
          ),
          PersistentTabConfig(
            screen: const FavoritesPage(),
            item: ItemConfig(
              icon: const Icon(Icons.favorite),
              title: "Favorites",
            ),
          ),
          PersistentTabConfig(
            screen: const ProfilePage(),
            item: ItemConfig(
              icon: const Icon(CupertinoIcons.profile_circled),
              title: "Profile",
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) =>
            Style6BottomNavBar(navBarConfig: navBarConfig),
      ),
    );
  }
}
