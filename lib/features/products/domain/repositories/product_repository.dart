import 'package:dartz/dartz.dart';
import 'package:fake_store/core/errors/failures.dart';
import 'package:fake_store/features/products/domain/entities/product.dart';

/// Repository interface for product operations
abstract class ProductRepository {
  /// Fetches all products from the catalog
  /// Returns Either<Failure, List<Product>>
  Future<Either<Failure, List<Product>>> getProducts();

  /// Fetches a single product by its ID
  /// Returns Either<Failure, Product>
  Future<Either<Failure, Product>> getProductById(int id);

  /// Searches products by query string (title or description)
  /// Returns Either<Failure, List<Product>>
  Future<Either<Failure, List<Product>>> searchProducts(String query);

  /// Fetches all available product categories
  /// Returns Either<Failure, List<String>>
  Future<Either<Failure, List<String>>> getCategories();

  /// Fetches products filtered by category
  /// Returns Either<Failure, List<Product>>
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
}
