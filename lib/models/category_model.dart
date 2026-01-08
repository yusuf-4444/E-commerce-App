import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';

class CategoryModel {
  final String id;
  final String name;
  final int productsCount;
  final Color bgColor;
  final Color textColor;

  CategoryModel({
    required this.id,
    required this.name,
    required this.productsCount,
    this.bgColor = AppColors.primary,
    this.textColor = AppColors.white,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'productsCount': productsCount,
      'bgColor': bgColor.value,
      'textColor': textColor.value,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      productsCount: (map['productsCount'] as num?)?.toInt() ?? 0,
      bgColor: _parseColor(map['bgColor']),
      textColor: _parseColor(map['textColor']),
    );
  }

  static Color _parseColor(dynamic colorValue) {
    try {
      if (colorValue is int) {
        return Color(colorValue);
      } else if (colorValue is String) {
        String hex = colorValue.replaceFirst('0x', '');
        return Color(int.parse('0xFF$hex'));
      }
      return Colors.grey;
    } catch (e) {
      return Colors.grey;
    }
  }
}

List<CategoryModel> dummyCategories = [
  CategoryModel(
    id: '1',
    name: 'New Arrivals',
    productsCount: 208,
    bgColor: const Color(0xFF9E9E9E),
    textColor: const Color(0xFF000000),
  ),
  CategoryModel(
    id: '2',
    name: 'Clothes',
    productsCount: 358,
    bgColor: AppColors.green,
    textColor: AppColors.white,
  ),
  CategoryModel(
    id: '3',
    name: 'Bags',
    productsCount: 160,
    bgColor: AppColors.black,
    textColor: AppColors.white,
  ),
  CategoryModel(
    id: '4',
    name: 'Shoes',
    productsCount: 230,
    bgColor: AppColors.grey,
    textColor: AppColors.black,
  ),
  CategoryModel(
    id: '5',
    name: 'Electronics',
    productsCount: 101,
    bgColor: AppColors.blue,
    textColor: AppColors.white,
  ),
];
