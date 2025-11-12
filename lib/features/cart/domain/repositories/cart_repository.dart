import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/cart_item.dart';

/// Repository interface for cart operations
abstract class CartRepository {
  /// Get all items in the cart
  ///
  /// Returns [Either<Failure, List<CartItem>>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains the list of cart items if successful
  Future<Either<Failure, List<CartItem>>> getCartItems();

  /// Add a product to the cart
  ///
  /// [product] - The product to add
  /// [quantity] - The quantity to add (default: 1)
  ///
  /// Returns [Either<Failure, void>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side indicates success
  Future<Either<Failure, void>> addToCart(Product product, int quantity);

  /// Update the quantity of a cart item
  ///
  /// [productId] - The ID of the product to update
  /// [quantity] - The new quantity
  ///
  /// Returns [Either<Failure, void>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side indicates success
  Future<Either<Failure, void>> updateCartItem(int productId, int quantity);

  /// Remove an item from the cart
  ///
  /// [productId] - The ID of the product to remove
  ///
  /// Returns [Either<Failure, void>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side indicates success
  Future<Either<Failure, void>> removeFromCart(int productId);

  /// Clear all items from the cart
  ///
  /// Returns [Either<Failure, void>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side indicates success
  Future<Either<Failure, void>> clearCart();

  /// Watch the cart item count
  ///
  /// Returns a [Stream<int>] that emits the current cart item count
  Stream<int> watchCartCount();
}
