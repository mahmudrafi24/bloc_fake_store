import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../products/domain/entities/product.dart';
import '../../domain/entities/wishlist_item.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_local_data_source.dart';

/// Implementation of WishlistRepository
class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<WishlistItem>>> getWishlistItems() async {
    try {
      final wishlistItems = await localDataSource.getWishlistItems();
      return Right(wishlistItems);
    } catch (e) {
      return Left(
        CacheFailure('Failed to get wishlist items: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(Product product) async {
    try {
      await localDataSource.addToWishlist(product);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to add to wishlist: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(int productId) async {
    try {
      await localDataSource.removeFromWishlist(productId);
      return const Right(null);
    } catch (e) {
      return Left(
        CacheFailure('Failed to remove from wishlist: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isInWishlist(int productId) async {
    try {
      final isInWishlist = await localDataSource.isInWishlist(productId);
      return Right(isInWishlist);
    } catch (e) {
      return Left(
        CacheFailure('Failed to check wishlist status: ${e.toString()}'),
      );
    }
  }
}
