import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/hive_service.dart';
import '../models/order_model.dart';

/// Abstract interface for order local data source
abstract class OrderLocalDataSource {
  /// Store an order in local storage
  /// Throws [CacheException] if the operation fails
  Future<void> storeOrder(OrderModel order);

  /// Get all orders from local storage
  /// Throws [CacheException] if the operation fails
  Future<List<OrderModel>> getOrders();

  /// Get a single order by ID from local storage
  /// Throws [CacheException] if the operation fails
  Future<OrderModel> getOrderById(int id);

  /// Clear all orders from local storage
  /// Throws [CacheException] if the operation fails
  Future<void> clearOrders();
}

/// Implementation of OrderLocalDataSource using Hive
class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final HiveService hiveService;

  OrderLocalDataSourceImpl({required this.hiveService});

  /// Get the orders box
  Future<Box<OrderModel>> _getOrdersBox() async {
    return await hiveService.getBox<OrderModel>(HiveBoxNames.orders);
  }

  @override
  Future<void> storeOrder(OrderModel order) async {
    try {
      final box = await _getOrdersBox();
      await box.put(order.id, order);
    } catch (e) {
      throw CacheException('Failed to store order: ${e.toString()}');
    }
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final box = await _getOrdersBox();
      // Return orders sorted by date (most recent first)
      final orders = box.values.toList();
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return orders;
    } catch (e) {
      throw CacheException('Failed to get orders: ${e.toString()}');
    }
  }

  @override
  Future<OrderModel> getOrderById(int id) async {
    try {
      final box = await _getOrdersBox();
      final order = box.get(id);

      if (order == null) {
        throw CacheException('Order with id $id not found');
      }

      return order;
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException('Failed to get order by id: ${e.toString()}');
    }
  }

  @override
  Future<void> clearOrders() async {
    try {
      final box = await _getOrdersBox();
      await box.clear();
    } catch (e) {
      throw CacheException('Failed to clear orders: ${e.toString()}');
    }
  }
}
