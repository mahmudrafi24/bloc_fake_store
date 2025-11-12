import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/wishlist_repository.dart';

/// Use case for removing a product from the wishlist
class RemoveFromWishlistUseCase
    extends UseCase<void, RemoveFromWishlistParams> {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromWishlistParams params) async {
    return await repository.removeFromWishlist(params.productId);
  }
}

/// Parameters for removing a product from the wishlist
class RemoveFromWishlistParams extends Equatable {
  final int productId;

  const RemoveFromWishlistParams({required this.productId});

  @override
  List<Object?> get props => [productId];
}
