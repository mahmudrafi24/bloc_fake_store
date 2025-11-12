import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/wishlist_item.dart';
import '../repositories/wishlist_repository.dart';

/// Use case for retrieving all wishlist items
class GetWishlistUseCase extends UseCase<List<WishlistItem>, NoParams> {
  final WishlistRepository repository;

  GetWishlistUseCase(this.repository);

  @override
  Future<Either<Failure, List<WishlistItem>>> call(NoParams params) async {
    return await repository.getWishlistItems();
  }
}
