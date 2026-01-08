part of 'category_cubit.dart';

class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {
  final List<CategoryModel> categories;
  CategorySuccess({required this.categories});
}

final class CategoryFailure extends CategoryState {
  final String message;
  CategoryFailure({required this.message});
}
