import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';

/// Base class for all cart events
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load cart items
class LoadCart extends CartEvent {
  const LoadCart();
}

/// Event to add a product to cart
class AddToCart extends CartEvent {
  final Product product;
  final int quantity;

  const AddToCart({required this.product, this.quantity = 1});

  @override
  List<Object?> get props => [product, quantity];
}

/// Event to update the quantity of a cart item
class UpdateQuantity extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateQuantity({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

/// Event to remove an item from cart
class RemoveItem extends CartEvent {
  final int productId;

  const RemoveItem({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event to clear all items from cart
class ClearCart extends CartEvent {
  const ClearCart();
}
