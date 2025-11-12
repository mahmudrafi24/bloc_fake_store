import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/order_model.dart';

/// Abstract interface for order remote data source
abstract class OrderRemoteDataSource {
  /// Create an order by posting to the carts endpoint (simulating order creation)
  /// The FakeStoreAPI doesn't have a dedicated orders endpoint, so we use /carts
  /// Throws [ServerException] if the request fails
  Future<OrderModel> createOrder(OrderModel order);
}

/// Implementation of OrderRemoteDataSource using ApiClient
class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;

  OrderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    try {
      // Prepare the cart data for the API
      // FakeStoreAPI expects cart format: { userId, date, products: [{productId, quantity}] }
      final cartData = {
        'userId': order.userId,
        'date': order.orderDate.toIso8601String(),
        'products': order.items.map((item) {
          return {'productId': item.product.id, 'quantity': item.quantity};
        }).toList(),
      };

      final response = await apiClient.post(ApiConstants.carts, data: cartData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // The API returns a cart with an ID, we'll use this as the order ID
        // and return the original order with the new ID
        final responseData = response.data as Map<String, dynamic>;
        final orderId = responseData['id'] as int;

        // Return the order with the assigned ID from the server
        return OrderModel(
          id: orderId,
          userId: order.userId,
          items: order.items,
          totalAmount: order.totalAmount,
          orderDate: order.orderDate,
          statusModel: order.statusModel,
          shippingAddress: order.shippingAddress,
        );
      } else {
        throw ServerException(
          'Failed to create order',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        _handleDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// Handle DioException and return appropriate error message
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Bad response: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error';
      case DioExceptionType.badCertificate:
        return 'Bad certificate';
      case DioExceptionType.unknown:
        return 'Unknown error: ${error.message}';
    }
  }
}
