import 'package:hive/hive.dart';
import '../../../products/data/models/product_model.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_item_model.g.dart';

/// CartItem model for data layer with JSON serialization and Hive persistence
@HiveType(typeId: 2)
class CartItemModel extends CartItem {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  final ProductModel product;

  @HiveField(2)
  @override
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.product,
    required this.quantity,
  }) : super(id: id, product: product, quantity: quantity);

  /// Create CartItemModel from JSON
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  /// Convert CartItemModel to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'product': product.toJson(), 'quantity': quantity};
  }

  /// Create CartItemModel from CartItem entity
  factory CartItemModel.fromEntity(CartItem cartItem) {
    return CartItemModel(
      id: cartItem.id,
      product: ProductModel.fromEntity(cartItem.product),
      quantity: cartItem.quantity,
    );
  }

  /// Create a copy with updated fields
  CartItemModel copyWith({int? id, ProductModel? product, int? quantity}) {
    return CartItemModel(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}
