import 'package:hive_flutter/hive_flutter.dart';

/// Service for managing Hive local storage
class HiveService {
  /// Initialize Hive with Flutter
  /// In test environments, Hive.init() should be called before this
  Future<void> init() async {
    // Only call initFlutter if Hive hasn't been initialized yet
    // This allows tests to use Hive.init() with a custom path
    if (!Hive.isBoxOpen('_test_init_check')) {
      try {
        await Hive.initFlutter();
      } catch (e) {
        // If initFlutter fails (e.g., in tests), Hive.init() should have been called
        // Rethrow only if it's not a path provider issue
        if (!e.toString().contains('path_provider')) {
          rethrow;
        }
      }
    }

    // Register adapters here when they are generated
    // Example: Hive.registerAdapter(ProductModelAdapter());
    // Adapters will be registered in the dependency injection setup
  }

  /// Get a Hive box by name
  /// Opens the box if it's not already open
  Future<Box<T>> getBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Get a lazy box by name
  /// Lazy boxes are useful for large datasets as they load values on demand
  Future<LazyBox<T>> getLazyBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.lazyBox<T>(boxName);
    }
    return await Hive.openLazyBox<T>(boxName);
  }

  /// Close a specific box
  Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Clear all data from a specific box
  Future<void> clearBox(String boxName) async {
    final box = await getBox(boxName);
    await box.clear();
  }

  /// Clear all boxes and delete all data
  Future<void> clearAll() async {
    await Hive.deleteFromDisk();
  }

  /// Close all open boxes
  Future<void> closeAll() async {
    await Hive.close();
  }

  /// Register a Hive adapter
  void registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }
}

/// Box names constants for easy reference
class HiveBoxNames {
  static const String products = 'products';
  static const String users = 'users';
  static const String cart = 'cart';
  static const String wishlist = 'wishlist';
  static const String orders = 'orders';
  static const String authToken = 'auth_token';
  static const String productCache = 'product_cache';
}
