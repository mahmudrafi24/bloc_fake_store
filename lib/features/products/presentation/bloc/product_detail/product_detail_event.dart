import 'package:equatable/equatable.dart';

/// Base class for ProductDetail events
abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load product details by ID
class LoadProductDetail extends ProductDetailEvent {
  final int productId;

  const LoadProductDetail(this.productId);

  @override
  List<Object?> get props => [productId];
}
