import 'package:hive/hive.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../../products/data/models/product_model.dart';
import '../../domain/entities/order.dart';

part 'order_model.g.dart';

/// Order model for data layer with JSON serialization and Hive persistence
@HiveType(typeId: 5)
class OrderModel extends Order {
  @HiveField(0)
  @override
  final int id;

  @HiveField(1)
  @override
  final int userId;

  @HiveField(2)
  final List<OrderItemModel> items;

  @HiveField(3)
  @override
  final double totalAmount;

  @HiveField(4)
  @override
  final DateTime orderDate;

  @HiveField(5)
  final OrderStatusModel statusModel;

  @HiveField(6)
  final AddressModel shippingAddress;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.statusModel,
    required this.shippingAddress,
  }) : super(
         id: id,
         userId: userId,
         items: items,
         totalAmount: totalAmount,
         orderDate: orderDate,
         status: statusModel.toEntity(),
         shippingAddress: shippingAddress,
       );

  /// Create OrderModel from JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      orderDate: DateTime.parse(json['orderDate'] as String),
      statusModel: OrderStatusModel.fromString(json['status'] as String),
      shippingAddress: AddressModel.fromJson(
        json['shippingAddress'] as Map<String, dynamic>,
      ),
    );
  }

  /// Convert OrderModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'status': statusModel.toString(),
      'shippingAddress': shippingAddress.toJson(),
    };
  }

  /// Create OrderModel from Order entity
  factory OrderModel.fromEntity(Order order) {
    return OrderModel(
      id: order.id,
      userId: order.userId,
      items: order.items
          .map((item) => OrderItemModel.fromEntity(item))
          .toList(),
      totalAmount: order.totalAmount,
      orderDate: order.orderDate,
      statusModel: OrderStatusModel.fromEntity(order.status),
      shippingAddress: order.shippingAddress is AddressModel
          ? order.shippingAddress as AddressModel
          : AddressModel(
              city: order.shippingAddress.city,
              street: order.shippingAddress.street,
              number: order.shippingAddress.number,
              zipcode: order.shippingAddress.zipcode,
              geolocation: order.shippingAddress.geolocation != null
                  ? GeolocationModel(
                      lat: order.shippingAddress.geolocation!.lat,
                      long: order.shippingAddress.geolocation!.long,
                    )
                  : null,
            ),
    );
  }
}

/// OrderItem model for data layer with JSON serialization and Hive persistence
@HiveType(typeId: 6)
class OrderItemModel extends OrderItem {
  @HiveField(0)
  final ProductModel product;

  @HiveField(1)
  @override
  final int quantity;

  @HiveField(2)
  @override
  final double price;

  OrderItemModel({
    required this.product,
    required this.quantity,
    required this.price,
  }) : super(product: product, quantity: quantity, price: price);

  /// Create OrderItemModel from JSON
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  /// Convert OrderItemModel to JSON
  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'quantity': quantity, 'price': price};
  }

  /// Create OrderItemModel from OrderItem entity
  factory OrderItemModel.fromEntity(OrderItem orderItem) {
    return OrderItemModel(
      product: ProductModel.fromEntity(orderItem.product),
      quantity: orderItem.quantity,
      price: orderItem.price,
    );
  }
}

/// OrderStatus model for Hive persistence
@HiveType(typeId: 7)
enum OrderStatusModel {
  @HiveField(0)
  pending,
  @HiveField(1)
  processing,
  @HiveField(2)
  shipped,
  @HiveField(3)
  delivered,
  @HiveField(4)
  cancelled;

  /// Convert to domain entity
  OrderStatus toEntity() {
    switch (this) {
      case OrderStatusModel.pending:
        return OrderStatus.pending;
      case OrderStatusModel.processing:
        return OrderStatus.processing;
      case OrderStatusModel.shipped:
        return OrderStatus.shipped;
      case OrderStatusModel.delivered:
        return OrderStatus.delivered;
      case OrderStatusModel.cancelled:
        return OrderStatus.cancelled;
    }
  }

  /// Create from domain entity
  static OrderStatusModel fromEntity(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return OrderStatusModel.pending;
      case OrderStatus.processing:
        return OrderStatusModel.processing;
      case OrderStatus.shipped:
        return OrderStatusModel.shipped;
      case OrderStatus.delivered:
        return OrderStatusModel.delivered;
      case OrderStatus.cancelled:
        return OrderStatusModel.cancelled;
    }
  }

  /// Create from string
  static OrderStatusModel fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatusModel.pending;
      case 'processing':
        return OrderStatusModel.processing;
      case 'shipped':
        return OrderStatusModel.shipped;
      case 'delivered':
        return OrderStatusModel.delivered;
      case 'cancelled':
        return OrderStatusModel.cancelled;
      default:
        return OrderStatusModel.pending;
    }
  }

  @override
  String toString() {
    return name;
  }
}
