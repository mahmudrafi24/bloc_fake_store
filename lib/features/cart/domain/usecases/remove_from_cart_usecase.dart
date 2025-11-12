import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Parameters for removing a product from cart
class RemoveFromCartParams extends Equatable {
  final int productId;

  const RemoveFromCartParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}

/// Use case for removing a product from the cart
class RemoveFromCartUseCase extends UseCase<void, RemoveFromCartParams> {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromCartParams params) async {
    return await repository.removeFromCart(params.productId);
  }
}
