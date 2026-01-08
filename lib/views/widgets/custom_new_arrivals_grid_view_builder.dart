import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/product_item_model.dart';
import 'package:flutter_ecommerce_app/utils/app_routes.dart';
import 'package:flutter_ecommerce_app/view_models.dart/home_cubit/home_cubit.dart';

class CustomNewArrivalsGridViewBuilder extends StatelessWidget {
  const CustomNewArrivalsGridViewBuilder({
    super.key,
    required this.dummyProducts1,
  });

  final List<ProductItemModel> dummyProducts1;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<HomeCubit>(context).getHomeData();
      },
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 13,
        ),
        itemCount: dummyProducts1.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                AppRoutes.productDetailsRoute,
                arguments: dummyProducts1[index].id,
              );
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 140,
                      child: Container(
                        width: 190,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CachedNetworkImage(
                            imageUrl: dummyProducts1[index].imgUrl,
                            placeholder: (context, url) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 1,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: BlocBuilder<HomeCubit, HomeState>(
                          bloc: BlocProvider.of<HomeCubit>(context),
                          buildWhen: (previous, current) =>
                              (current is HomeFavoriteLoading &&
                                  current.productID ==
                                      dummyProducts1[index].id) ||
                              (current is HomeFavoriteSuccess &&
                                  current.productID ==
                                      dummyProducts1[index].id) ||
                              (current is HomeFavoriteFaliure &&
                                  current.productID ==
                                      dummyProducts1[index].id),
                          builder: (context, state) {
                            if (state is HomeFavoriteLoading) {
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            } else if (state is HomeFavoriteSuccess) {
                              if (state.isFavorite) {
                                return IconButton(
                                  onPressed: () {
                                    BlocProvider.of<HomeCubit>(
                                      context,
                                    ).setFavorite(dummyProducts1[index]);
                                  },
                                  icon: const Icon(
                                    Icons.favorite_border_outlined,
                                  ),
                                );
                              } else {
                                return IconButton(
                                  onPressed: () {
                                    BlocProvider.of<HomeCubit>(
                                      context,
                                    ).setFavorite(dummyProducts1[index]);
                                  },
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                );
                              }
                            }
                            return IconButton(
                              onPressed: () {
                                BlocProvider.of<HomeCubit>(
                                  context,
                                ).setFavorite(dummyProducts1[index]);
                              },
                              icon: dummyProducts1[index].isFavorite == true
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite_border_outlined),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  dummyProducts1[index].name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  dummyProducts1[index].category,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                ),
                Text(
                  "\$${dummyProducts1[index].price}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
