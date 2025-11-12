import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

/// Base class for all cart states
abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any cart operations
class CartInitial extends CartState {
  const CartInitial();
}

/// State when cart operations are in progress
class CartLoading extends CartState {
  const CartLoading();
}

/// State when cart items are successfully loaded
class CartLoaded extends CartState {
  final List<CartItem> items;
  final int itemCount;
  final double totalPrice;

  const CartLoaded({
    required this.items,
    required this.itemCount,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [items, itemCount, totalPrice];

  /// Create a copy of this state with updated values
  CartLoaded copyWith({
    List<CartItem>? items,
    int? itemCount,
    double? totalPrice,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      itemCount: itemCount ?? this.itemCount,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

/// State when a cart operation fails
class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object?> get props => [message];
}
