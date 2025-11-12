import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/cart_repository.dart';

/// Parameters for updating a cart item quantity
class UpdateCartItemParams extends Equatable {
  final int productId;
  final int quantity;

  const UpdateCartItemParams({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

/// Use case for updating the quantity of a cart item
class UpdateCartItemUseCase extends UseCase<void, UpdateCartItemParams> {
  final CartRepository repository;

  UpdateCartItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateCartItemParams params) async {
    return await repository.updateCartItem(params.productId, params.quantity);
  }
}
