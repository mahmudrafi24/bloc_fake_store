import 'package:equatable/equatable.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../products/domain/entities/product.dart';

/// Order entity representing a customer order
class Order extends Equatable {
  final int id;
  final int userId;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status;
  final Address shippingAddress;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    items,
    totalAmount,
    orderDate,
    status,
    shippingAddress,
  ];
}

/// OrderItem entity representing a product item within an order
class OrderItem extends Equatable {
  final Product product;
  final int quantity;
  final double price;

  const OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  /// Calculate subtotal for this order item
  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [product, quantity, price];
}

/// OrderStatus enum representing the current status of an order
enum OrderStatus { pending, processing, shipped, delivered, cancelled }
