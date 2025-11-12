import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/cart_repository.dart';

/// Parameters for adding a product to cart
class AddToCartParams extends Equatable {
  final Product product;
  final int quantity;

  const AddToCartParams({required this.product, this.quantity = 1});

  @override
  List<Object?> get props => [product, quantity];
}

/// Use case for adding a product to the cart
class AddToCartUseCase extends UseCase<void, AddToCartParams> {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToCartParams params) async {
    return await repository.addToCart(params.product, params.quantity);
  }
}
