import 'dart:async';
import 'package:hive/hive.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/data/models/product_model.dart';
import '../models/cart_item_model.dart';

/// Abstract interface for cart local data source
abstract class CartLocalDataSource {
  /// Get all cart items from local storage
  Future<List<CartItemModel>> getCartItems();

  /// Add a product to the cart
  /// If the product already exists, increment its quantity
  Future<void> addToCart(Product product, int quantity);

  /// Update the quantity of a cart item
  Future<void> updateCartItem(int productId, int quantity);

  /// Remove a cart item from local storage
  Future<void> removeFromCart(int productId);

  /// Clear all cart items from local storage
  Future<void> clearCart();

  /// Watch the cart item count
  Stream<int> watchCartCount();

  /// Get the total price of all items in the cart
  Future<double> getTotalPrice();

  /// Get the total number of items in the cart
  Future<int> getCartCount();
}

/// Implementation of CartLocalDataSource using Hive
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final HiveService hiveService;
  final StreamController<int> _cartCountController =
      StreamController<int>.broadcast();

  CartLocalDataSourceImpl({required this.hiveService});

  /// Get the cart box
  Future<Box<CartItemModel>> _getCartBox() async {
    return await hiveService.getBox<CartItemModel>(HiveBoxNames.cart);
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final box = await _getCartBox();
      return box.values.toList();
    } catch (e) {
      throw Exception('Failed to get cart items: $e');
    }
  }

  @override
  Future<void> addToCart(Product product, int quantity) async {
    try {
      final box = await _getCartBox();

      // Check if product already exists in cart
      final existingItem = box.values.firstWhere(
        (item) => item.product.id == product.id,
        orElse: () => const CartItemModel(
          id: -1,
          product: ProductModel(
            id: -1,
            title: '',
            price: 0,
            description: '',
            category: '',
            image: '',
          ),
          quantity: 0,
        ),
      );

      if (existingItem.id != -1) {
        // Product exists, update quantity
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity + quantity,
        );
        await box.put(existingItem.id, updatedItem);
      } else {
        // New product, add to cart
        final newId = box.isEmpty
            ? 1
            : box.values.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
        final newItem = CartItemModel(
          id: newId,
          product: ProductModel.fromEntity(product),
          quantity: quantity,
        );
        await box.put(newId, newItem);
      }

      // Notify cart count change
      _notifyCartCountChange();
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  @override
  Future<void> updateCartItem(int productId, int quantity) async {
    try {
      final box = await _getCartBox();

      // Find the cart item with the matching product ID
      final cartItem = box.values.firstWhere(
        (item) => item.product.id == productId,
        orElse: () => throw Exception('Cart item not found'),
      );

      if (quantity <= 0) {
        // Remove item if quantity is 0 or negative
        await box.delete(cartItem.id);
      } else {
        // Update quantity
        final updatedItem = cartItem.copyWith(quantity: quantity);
        await box.put(cartItem.id, updatedItem);
      }

      // Notify cart count change
      _notifyCartCountChange();
    } catch (e) {
      throw Exception('Failed to update cart item: $e');
    }
  }

  @override
  Future<void> removeFromCart(int productId) async {
    try {
      final box = await _getCartBox();

      // Find the cart item with the matching product ID
      final cartItem = box.values.firstWhere(
        (item) => item.product.id == productId,
        orElse: () => throw Exception('Cart item not found'),
      );

      await box.delete(cartItem.id);

      // Notify cart count change
      _notifyCartCountChange();
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final box = await _getCartBox();
      await box.clear();

      // Notify cart count change
      _notifyCartCountChange();
    } catch (e) {
      throw Exception('Failed to clear cart: $e');
    }
  }

  @override
  Stream<int> watchCartCount() {
    // Emit initial count
    getCartCount().then((count) => _cartCountController.add(count));
    return _cartCountController.stream;
  }

  @override
  Future<double> getTotalPrice() async {
    try {
      final items = await getCartItems();
      return items.fold<double>(0.0, (sum, item) => sum + item.subtotal);
    } catch (e) {
      throw Exception('Failed to calculate total price: $e');
    }
  }

  @override
  Future<int> getCartCount() async {
    try {
      final items = await getCartItems();
      return items.fold<int>(0, (sum, item) => sum + item.quantity);
    } catch (e) {
      throw Exception('Failed to get cart count: $e');
    }
  }

  /// Notify listeners about cart count change
  Future<void> _notifyCartCountChange() async {
    final count = await getCartCount();
    _cartCountController.add(count);
  }

  /// Dispose the stream controller
  void dispose() {
    _cartCountController.close();
  }
}
