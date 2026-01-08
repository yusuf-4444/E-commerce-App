import 'package:flutter_ecommerce_app/models/product_item_model.dart';

class AddToCartModel {
  final String id;
  final ProductItemModel productId;
  final int quantity;
  final ProductSize? selectedSize;

  AddToCartModel({
    required this.productId,
    required this.id,
    required this.quantity,
    this.selectedSize,
  });

  AddToCartModel copyWith({
    String? id,
    int? quantity,
    ProductSize? selectedSize,
    ProductItemModel? productId,
  }) {
    return AddToCartModel(
      selectedSize: selectedSize ?? this.selectedSize,
      id: id ?? this.id,
      quantity: quantity ?? this.quantity,
      productId: productId ?? this.productId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'productId': productId.toMap(),
      'quantity': quantity,
      'selectedSize': selectedSize?.name,
    };
  }

  factory AddToCartModel.fromMap(Map<String, dynamic> map) {
    return AddToCartModel(
      id: map['id'] as String,
      productId: ProductItemModel.fromMap(map['productId']),
      quantity: map['quantity'] as int,
      selectedSize: ProductSize.fromString(map['selectedSize']),
    );
  }
}
