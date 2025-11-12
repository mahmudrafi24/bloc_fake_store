import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../entities/order.dart';

/// Repository interface for order operations
abstract class OrderRepository {
  /// Create a new order from cart items
  ///
  /// [items] - The list of cart items to include in the order
  /// [address] - The shipping address for the order
  ///
  /// Returns [Either<Failure, Order>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains the created order if successful
  Future<Either<Failure, Order>> createOrder(
    List<CartItem> items,
    Address address,
  );

  /// Get all orders for the current user
  ///
  /// Returns [Either<Failure, List<Order>>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains the list of orders if successful
  Future<Either<Failure, List<Order>>> getOrders();

  /// Get a specific order by its ID
  ///
  /// [id] - The ID of the order to retrieve
  ///
  /// Returns [Either<Failure, Order>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains the order if successful
  Future<Either<Failure, Order>> getOrderById(int id);
}
