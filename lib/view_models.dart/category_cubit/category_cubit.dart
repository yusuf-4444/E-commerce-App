import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/category_model.dart';
import 'package:flutter_ecommerce_app/services/home_service.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  final HomeServiceImpl _homeServiceImpl = HomeServiceImpl();

  Future<void> getCategory() async {
    emit(CategoryLoading());

    try {
      final categories = await _homeServiceImpl.getCategoriesData();
      emit(CategorySuccess(categories: categories));
    } catch (e) {
      emit(CategoryFailure(message: e.toString()));
    }

    // Future.delayed(const Duration(seconds: 2), () {
    //   emit(CategorySuccess(categories: dummyCategories));
    // });
  }
}
