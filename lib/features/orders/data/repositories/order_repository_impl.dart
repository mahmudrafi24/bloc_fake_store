import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../authentication/data/datasources/auth_local_data_source.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../products/data/models/product_model.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';

/// Implementation of OrderRepository
/// Coordinates between remote and local data sources
/// Stores orders locally after creation
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final NetworkInfo networkInfo;

  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Order>> createOrder(
    List<CartItem> items,
    Address address,
  ) async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        return const Left(
          NetworkFailure('No internet connection. Cannot create order.'),
        );
      }

      // Validate that cart has items
      if (items.isEmpty) {
        return const Left(
          ValidationFailure('Cannot create order with empty cart'),
        );
      }

      // Get current user ID
      final user = await authLocalDataSource.getCachedUser();
      if (user == null) {
        return const Left(ValidationFailure('User not authenticated'));
      }

      // Calculate total amount
      final totalAmount = items.fold<double>(
        0.0,
        (sum, item) => sum + item.subtotal,
      );

      // Create order model
      final orderModel = OrderModel(
        id: 0, // Will be assigned by the server
        userId: user.id,
        items: items
            .map(
              (item) => OrderItemModel(
                product: ProductModel.fromEntity(item.product),
                quantity: item.quantity,
                price: item.product.price,
              ),
            )
            .toList(),
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        statusModel: OrderStatusModel.pending,
        shippingAddress: address is AddressModel
            ? address
            : AddressModel(
                city: address.city,
                street: address.street,
                number: address.number,
                zipcode: address.zipcode,
                geolocation: address.geolocation != null
                    ? GeolocationModel(
                        lat: address.geolocation!.lat,
                        long: address.geolocation!.long,
                      )
                    : null,
              ),
      );

      // Create order via remote data source
      final createdOrder = await remoteDataSource.createOrder(orderModel);

      // Store order locally
      await localDataSource.storeOrder(createdOrder);

      return Right(createdOrder);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      // Get orders from local storage
      // Orders are stored locally after creation
      final orders = await localDataSource.getOrders();

      return Right(orders);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get orders: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(int id) async {
    try {
      // Get order from local storage
      final order = await localDataSource.getOrderById(id);

      return Right(order);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Failed to get order: ${e.toString()}'));
    }
  }
}
