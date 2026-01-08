import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models.dart/favorite_cubit/favorite_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<FavoriteCubit>(context);
    return Scaffold(
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        bloc: cubit,
        buildWhen: (previous, current) =>
            current is FavoriteSuccess ||
            current is FavoriteFaliure ||
            current is FavoriteLoading,
        builder: (context, state) {
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is FavoriteSuccess) {
            return RefreshIndicator(
              onRefresh: cubit.getFavorites,
              child: ListView.builder(
                itemCount: state.favoriteProducts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.shade100,
                              ),
                              child:
                                  state
                                      .favoriteProducts[index]
                                      .imgUrl
                                      .isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        state.favoriteProducts[index].imgUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(
                                              Icons
                                                  .image_not_supported_outlined,
                                              color: Colors.grey,
                                              size: 40,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                            ),

                            const SizedBox(width: 16),

                            // Product Information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.favoriteProducts[index].name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    '\$${state.favoriteProducts[index].price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Favorite badge
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Colors.red.shade100,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.red.shade400,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Favorite',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.red.shade400,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Delete button
                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    cubit.removeFavorites(
                                      state.favoriteProducts[index],
                                    );
                                  },
                                  icon: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red.shade400,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Optional: Add to cart or view details button
                                OutlinedButton(
                                  onPressed: () {
                                    // Navigate to product details or add to cart
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    side: BorderSide(
                                      color: Colors.blue.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    'View',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is FavoriteFaliure) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
