import 'package:equatable/equatable.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../cart/domain/entities/cart_item.dart';

/// Base class for all order events
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all orders for the current user
class LoadOrders extends OrderEvent {
  const LoadOrders();
}

/// Event to create a new order
class CreateOrder extends OrderEvent {
  final List<CartItem> items;
  final Address address;

  const CreateOrder({required this.items, required this.address});

  @override
  List<Object?> get props => [items, address];
}

/// Event to load details of a specific order
class LoadOrderDetail extends OrderEvent {
  final int orderId;

  const LoadOrderDetail({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}
