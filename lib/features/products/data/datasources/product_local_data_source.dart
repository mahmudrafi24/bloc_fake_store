import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/hive_service.dart';
import '../models/product_model.dart';

/// Abstract interface for product local data source
abstract class ProductLocalDataSource {
  /// Cache products in local storage
  /// Throws [CacheException] if the operation fails
  Future<void> cacheProducts(List<ProductModel> products);

  /// Get cached products from local storage
  /// Throws [CacheException] if no cached data is found or operation fails
  Future<List<ProductModel>> getCachedProducts();

  /// Cache a single product in local storage
  /// Throws [CacheException] if the operation fails
  Future<void> cacheProduct(ProductModel product);

  /// Get a cached product by ID from local storage
  /// Throws [CacheException] if product is not found or operation fails
  Future<ProductModel> getCachedProductById(int id);

  /// Check if cache is expired (older than 1 hour)
  Future<bool> isCacheExpired();

  /// Clear all cached products
  Future<void> clearCache();
}

/// Implementation of ProductLocalDataSource using Hive
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final HiveService hiveService;
  static const String _cacheTimestampKey = 'products_cache_timestamp';

  ProductLocalDataSourceImpl({required this.hiveService});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final box = await hiveService.getBox<ProductModel>(
        HiveBoxNames.productCache,
      );

      // Clear existing products
      await box.clear();

      // Store products with their IDs as keys
      for (final product in products) {
        await box.put(product.id, product);
      }

      // Store cache timestamp
      final timestampBox = await hiveService.getBox<int>('cache_metadata');
      await timestampBox.put(
        _cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw CacheException('Failed to cache products: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    try {
      final box = await hiveService.getBox<ProductModel>(
        HiveBoxNames.productCache,
      );

      if (box.isEmpty) {
        throw CacheException('No cached products found');
      }

      return box.values.toList();
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException('Failed to get cached products: ${e.toString()}');
    }
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    try {
      final box = await hiveService.getBox<ProductModel>(
        HiveBoxNames.productCache,
      );

      await box.put(product.id, product);
    } catch (e) {
      throw CacheException('Failed to cache product: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getCachedProductById(int id) async {
    try {
      final box = await hiveService.getBox<ProductModel>(
        HiveBoxNames.productCache,
      );

      final product = box.get(id);

      if (product == null) {
        throw CacheException('Product with id $id not found in cache');
      }

      return product;
    } catch (e) {
      if (e is CacheException) {
        rethrow;
      }
      throw CacheException(
        'Failed to get cached product by id: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isCacheExpired() async {
    try {
      final timestampBox = await hiveService.getBox<int>('cache_metadata');
      final timestamp = timestampBox.get(_cacheTimestampKey);

      if (timestamp == null) {
        return true; // No cache timestamp means cache is expired
      }

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(cacheTime);

      return difference > ApiConstants.cacheDuration;
    } catch (e) {
      // If we can't determine cache age, consider it expired
      return true;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await hiveService.getBox<ProductModel>(
        HiveBoxNames.productCache,
      );
      await box.clear();

      final timestampBox = await hiveService.getBox<int>('cache_metadata');
      await timestampBox.delete(_cacheTimestampKey);
    } catch (e) {
      throw CacheException('Failed to clear cache: ${e.toString()}');
    }
  }
}
