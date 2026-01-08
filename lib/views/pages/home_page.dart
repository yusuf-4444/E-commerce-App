import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/views/pages/category_tab_view.dart';
import 'package:flutter_ecommerce_app/views/widgets/home_tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                // CustomAppBar(),
                TabBar(
                  unselectedLabelColor: AppColors.grey,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Home", icon: Icon(CupertinoIcons.home)),
                    Tab(text: "Category", icon: Icon(Icons.category)),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [HomeTabView(), CategoryTabView()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
