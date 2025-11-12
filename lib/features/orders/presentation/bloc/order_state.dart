import 'package:equatable/equatable.dart';
import '../../domain/entities/order.dart';

/// Base class for all order states
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any order operations
class OrderInitial extends OrderState {
  const OrderInitial();
}

/// State when order operations are in progress
class OrderLoading extends OrderState {
  const OrderLoading();
}

/// State when orders are successfully loaded
class OrdersLoaded extends OrderState {
  final List<Order> orders;

  const OrdersLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];
}

/// State when an order is successfully created
class OrderCreated extends OrderState {
  final Order order;

  const OrderCreated({required this.order});

  @override
  List<Object?> get props => [order];
}

/// State when order detail is successfully loaded
class OrderDetailLoaded extends OrderState {
  final Order order;

  const OrderDetailLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

/// State when an order operation fails
class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}
