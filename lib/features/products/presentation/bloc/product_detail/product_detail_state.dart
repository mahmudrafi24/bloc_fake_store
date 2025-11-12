import 'package:equatable/equatable.dart';
import 'package:fake_store/features/products/domain/entities/product.dart';

/// Base class for ProductDetail states
abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

/// Initial state before product details are loaded
class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();
}

/// State when product details are being loaded
class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

/// State when product details are successfully loaded
class ProductDetailLoaded extends ProductDetailState {
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

/// State when there's an error loading product details
class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
