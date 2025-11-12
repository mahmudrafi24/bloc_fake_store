import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../entities/wishlist_item.dart';

/// Repository interface for wishlist operations
abstract class WishlistRepository {
  /// Retrieves all items in the wishlist
  ///
  /// Returns [Either<Failure, List<WishlistItem>>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains the list of wishlist items if successful
  Future<Either<Failure, List<WishlistItem>>> getWishlistItems();

  /// Adds a product to the wishlist
  ///
  /// Returns [Either<Failure, void>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side indicates success
  Future<Either<Failure, void>> addToWishlist(Product product);

  /// Removes a product from the wishlist
  ///
  /// [productId] The ID of the product to remove
  ///
  /// Returns [Either<Failure, void>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side indicates success
  Future<Either<Failure, void>> removeFromWishlist(int productId);

  /// Checks if a product is in the wishlist
  ///
  /// [productId] The ID of the product to check
  ///
  /// Returns [Either<Failure, bool>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains true if the product is in the wishlist, false otherwise
  Future<Either<Failure, bool>> isInWishlist(int productId);
}
