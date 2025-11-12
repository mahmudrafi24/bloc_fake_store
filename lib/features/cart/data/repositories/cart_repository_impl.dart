import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

/// Implementation of CartRepository
class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems() async {
    try {
      final cartItems = await localDataSource.getCartItems();
      return Right(cartItems);
    } catch (e) {
      return Left(CacheFailure('Failed to get cart items: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(Product product, int quantity) async {
    try {
      // Validate quantity
      if (quantity <= 0) {
        return const Left(ValidationFailure('Quantity must be greater than 0'));
      }

      await localDataSource.addToCart(product, quantity);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add to cart: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateCartItem(
    int productId,
    int quantity,
  ) async {
    try {
      // Validate quantity
      if (quantity < 0) {
        return const Left(ValidationFailure('Quantity cannot be negative'));
      }

      await localDataSource.updateCartItem(productId, quantity);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to update cart item: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromCart(int productId) async {
    try {
      await localDataSource.removeFromCart(productId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to remove from cart: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear cart: ${e.toString()}'));
    }
  }

  @override
  Stream<int> watchCartCount() {
    return localDataSource.watchCartCount();
  }
}
