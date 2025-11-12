import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../products/domain/entities/product.dart';
import '../repositories/wishlist_repository.dart';

/// Use case for adding a product to the wishlist
class AddToWishlistUseCase extends UseCase<void, AddToWishlistParams> {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddToWishlistParams params) async {
    return await repository.addToWishlist(params.product);
  }
}

/// Parameters for adding a product to the wishlist
class AddToWishlistParams extends Equatable {
  final Product product;

  const AddToWishlistParams({required this.product});

  @override
  List<Object?> get props => [product];
}
