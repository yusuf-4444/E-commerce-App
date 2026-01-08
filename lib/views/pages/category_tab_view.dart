import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/view_models.dart/category_cubit/category_cubit.dart';

class CategoryTabView extends StatelessWidget {
  const CategoryTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      bloc: BlocProvider.of<CategoryCubit>(context),
      buildWhen: (previous, current) =>
          current is CategorySuccess ||
          current is CategoryFailure ||
          current is CategoryLoading,
      builder: (context, state) {
        if (state is CategoryFailure) {
          return Center(child: Text(state.message));
        } else if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is CategorySuccess) {
          return ListView.builder(
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: category.bgColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 32,
                    ),
                    child: Column(
                      children: [
                        Text(
                          category.name,
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(
                                color: category.textColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          "${category.productsCount} Products",
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(
                                color: category.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
