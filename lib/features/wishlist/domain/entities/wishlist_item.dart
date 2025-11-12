import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';

/// WishlistItem entity representing a product saved in the user's wishlist
class WishlistItem extends Equatable {
  final int id;
  final Product product;
  final DateTime addedAt;

  const WishlistItem({
    required this.id,
    required this.product,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [id, product, addedAt];
}
