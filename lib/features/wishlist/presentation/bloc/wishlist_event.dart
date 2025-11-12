import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';

/// Base class for all wishlist events
abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load wishlist items
class LoadWishlist extends WishlistEvent {
  const LoadWishlist();
}

/// Event to add a product to wishlist
class AddToWishlist extends WishlistEvent {
  final Product product;

  const AddToWishlist({required this.product});

  @override
  List<Object?> get props => [product];
}

/// Event to remove a product from wishlist
class RemoveFromWishlist extends WishlistEvent {
  final int productId;

  const RemoveFromWishlist({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Event to check if a product is in the wishlist
class CheckWishlistStatus extends WishlistEvent {
  final int productId;

  const CheckWishlistStatus({required this.productId});

  @override
  List<Object?> get props => [productId];
}
