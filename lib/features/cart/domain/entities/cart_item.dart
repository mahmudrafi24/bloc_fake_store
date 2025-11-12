import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';

/// CartItem entity representing an item in the shopping cart
class CartItem extends Equatable {
  final int id;
  final Product product;
  final int quantity;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  /// Calculate subtotal for this cart item
  double get subtotal => product.price * quantity;

  @override
  List<Object?> get props => [id, product, quantity];
}
