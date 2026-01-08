import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models.dart/home_cubit/home_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_carousel_options.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_new_arrivals_grid_view_builder.dart';
import 'package:flutter_ecommerce_app/views/widgets/new_arrivals_row.dart';

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: BlocProvider.of<HomeCubit>(context),
      buildWhen: (previous, current) =>
          current is HomeLoading ||
          current is HomeSuccess ||
          current is HomeFaliure,
      builder: (context, state) {
        if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is HomeSuccess) {
          return SingleChildScrollView(
            child: RefreshIndicator(
              onRefresh: () async {
                BlocProvider.of<HomeCubit>(context).getHomeData();
              },
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  CustomCarouselOptions(
                    dummyHomeCarouselItems1: state.homeCarouselItemModel,
                  ),
                  const SizedBox(height: 25),
                  const NewArrivalsRow(),
                  const SizedBox(height: 16),
                  CustomNewArrivalsGridViewBuilder(
                    dummyProducts1: state.productItemModel,
                  ),
                ],
              ),
            ),
          );
        } else if (state is HomeFaliure) {
          return Center(child: Text(state.message));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
