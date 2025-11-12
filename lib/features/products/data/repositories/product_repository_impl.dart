import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

/// Implementation of ProductRepository
/// Coordinates between remote and local data sources
/// Implements cache-first strategy with background refresh
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      // Check if cache is expired
      final isCacheExpired = await localDataSource.isCacheExpired();

      // Try to get cached products first
      if (!isCacheExpired) {
        try {
          final cachedProducts = await localDataSource.getCachedProducts();
          // Return cached products and refresh in background if online
          _refreshCacheInBackground();
          return Right(cachedProducts);
        } catch (e) {
          // Cache miss or error, continue to fetch from remote
        }
      }

      // Check network connectivity
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        // Offline: try to serve from cache even if expired
        try {
          final cachedProducts = await localDataSource.getCachedProducts();
          return Right(cachedProducts);
        } catch (e) {
          return const Left(
            NetworkFailure(
              'No internet connection and no cached data available',
            ),
          );
        }
      }

      // Online: fetch from remote
      final products = await remoteDataSource.getProducts();

      // Cache the fetched products
      await localDataSource.cacheProducts(products);

      return Right(products);
    } on ServerException catch (e) {
      // Try to serve from cache on server error
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        return Right(cachedProducts);
      } catch (_) {
        return Left(ServerFailure(e.message));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      // Try to get from cache first
      try {
        final cachedProduct = await localDataSource.getCachedProductById(id);
        return Right(cachedProduct);
      } catch (e) {
        // Cache miss, continue to fetch from remote
      }

      // Check network connectivity
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        return const Left(
          NetworkFailure('No internet connection and product not in cache'),
        );
      }

      // Fetch from remote
      final product = await remoteDataSource.getProductById(id);

      // Cache the fetched product
      await localDataSource.cacheProduct(product);

      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      // Get all products (from cache or remote)
      final productsResult = await getProducts();

      return productsResult.fold((failure) => Left(failure), (products) {
        // Filter products by query (case-insensitive search in title and description)
        final filteredProducts = products.where((product) {
          final lowerQuery = query.toLowerCase();
          final titleMatch = product.title.toLowerCase().contains(lowerQuery);
          final descriptionMatch = product.description.toLowerCase().contains(
            lowerQuery,
          );
          return titleMatch || descriptionMatch;
        }).toList();

        return Right(filteredProducts);
      });
    } catch (e) {
      return Left(ServerFailure('Search failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        // Offline: extract categories from cached products
        try {
          final cachedProducts = await localDataSource.getCachedProducts();
          final categories = cachedProducts
              .map((product) => product.category)
              .toSet()
              .toList();
          return Right(categories);
        } catch (e) {
          return const Left(
            NetworkFailure(
              'No internet connection and no cached data available',
            ),
          );
        }
      }

      // Online: fetch from remote
      final categories = await remoteDataSource.getCategories();

      return Right(categories);
    } on ServerException catch (e) {
      // Try to extract from cache on server error
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        final categories = cachedProducts
            .map((product) => product.category)
            .toSet()
            .toList();
        return Right(categories);
      } catch (_) {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String category,
  ) async {
    try {
      // Check network connectivity
      final isConnected = await networkInfo.isConnected;

      if (!isConnected) {
        // Offline: filter cached products by category
        try {
          final cachedProducts = await localDataSource.getCachedProducts();
          final filteredProducts = cachedProducts
              .where((product) => product.category == category)
              .toList();
          return Right(filteredProducts);
        } catch (e) {
          return const Left(
            NetworkFailure(
              'No internet connection and no cached data available',
            ),
          );
        }
      }

      // Online: fetch from remote
      final products = await remoteDataSource.getProductsByCategory(category);

      return Right(products);
    } on ServerException catch (e) {
      // Try to filter from cache on server error
      try {
        final cachedProducts = await localDataSource.getCachedProducts();
        final filteredProducts = cachedProducts
            .where((product) => product.category == category)
            .toList();
        return Right(filteredProducts);
      } catch (_) {
        return Left(ServerFailure(e.message));
      }
    } catch (e) {
      return Left(ServerFailure('Unexpected error: ${e.toString()}'));
    }
  }

  /// Refresh cache in background without blocking the current operation
  void _refreshCacheInBackground() {
    // Fire and forget - refresh cache in background
    Future.microtask(() async {
      try {
        final isConnected = await networkInfo.isConnected;
        if (isConnected) {
          final products = await remoteDataSource.getProducts();
          await localDataSource.cacheProducts(products);
        }
      } catch (e) {
        // Silently fail - this is a background operation
        // The user already has cached data
      }
    });
  }
}
