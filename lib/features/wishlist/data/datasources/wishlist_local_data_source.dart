import 'package:hive/hive.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/data/models/product_model.dart';
import '../models/wishlist_item_model.dart';

/// Abstract interface for wishlist local data source
abstract class WishlistLocalDataSource {
  /// Get all wishlist items from local storage
  Future<List<WishlistItemModel>> getWishlistItems();

  /// Add a product to the wishlist
  Future<void> addToWishlist(Product product);

  /// Remove a product from the wishlist
  Future<void> removeFromWishlist(int productId);

  /// Check if a product is in the wishlist
  Future<bool> isInWishlist(int productId);
}

/// Implementation of WishlistLocalDataSource using Hive
class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final HiveService hiveService;

  WishlistLocalDataSourceImpl({required this.hiveService});

  /// Get the wishlist box
  Future<Box<WishlistItemModel>> _getWishlistBox() async {
    return await hiveService.getBox<WishlistItemModel>(HiveBoxNames.wishlist);
  }

  @override
  Future<List<WishlistItemModel>> getWishlistItems() async {
    try {
      final box = await _getWishlistBox();
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to get wishlist items: $e');
    }
  }

  @override
  Future<void> addToWishlist(Product product) async {
    try {
      final box = await _getWishlistBox();

      // Check if product already exists in wishlist
      final existingItem = box.values.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => WishlistItemModel(
          id: -1,
          product: const ProductModel(
            id: -1,
            title: '',
            price: 0,
            description: '',
            category: '',
            image: '',
          ),
          addedAt: DateTime.now(),
        ),
      );

      // Don't add if already exists
      if (existingItem.id != -1) {
        return;
      }

      // Generate new ID
      final newId = box.isEmpty
          ? 1
          : box.values.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;

      // Create new wishlist item
      final newItem = WishlistItemModel(
        id: newId,
        product: ProductModel.fromEntity(product),
        addedAt: DateTime.now(),
      );

      await box.put(newId, newItem);
    } catch (e) {
      throw Exception('Failed to add to wishlist: $e');
    }
  }

  @override
  Future<void> removeFromWishlist(int productId) async {
    try {
      final box = await _getWishlistBox();

      // Find the wishlist item with the matching product ID
      final wishlistItem = box.values.firstWhere(
        (item) => item.product.id == productId,
        orElse: () => throw Exception('Wishlist item not found'),
      );

      await box.delete(wishlistItem.id);
    } catch (e) {
      throw Exception('Failed to remove from wishlist: $e');
    }
  }

  @override
  Future<bool> isInWishlist(int productId) async {
    try {
      final box = await _getWishlistBox();

      // Check if any item has the matching product ID
      return box.values.any((item) => item.product.id == productId);
    } catch (e) {
      throw Exception('Failed to check wishlist status: $e');
    }
  }
}
