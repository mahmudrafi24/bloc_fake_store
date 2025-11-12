import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'core/network/api_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/hive_service.dart';
import 'features/authentication/data/datasources/auth_local_data_source.dart';
import 'features/authentication/data/datasources/auth_remote_data_source.dart';
import 'features/authentication/data/models/user_model.dart';
import 'features/authentication/data/repositories/auth_repository_impl.dart';
import 'features/authentication/domain/repositories/auth_repository.dart';
import 'features/authentication/domain/usecases/get_current_user_usecase.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/domain/usecases/logout_usecase.dart';
import 'features/authentication/domain/usecases/register_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/products/data/datasources/product_local_data_source.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'features/products/data/models/product_model.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/domain/usecases/get_categories_usecase.dart';
import 'features/products/domain/usecases/get_product_detail_usecase.dart';
import 'features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/domain/usecases/search_products_usecase.dart';
import 'features/products/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'features/products/presentation/bloc/product_list/product_list_bloc.dart';
import 'features/cart/data/datasources/cart_local_data_source.dart';
import 'features/cart/data/models/cart_item_model.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/domain/usecases/add_to_cart_usecase.dart';
import 'features/cart/domain/usecases/clear_cart_usecase.dart';
import 'features/cart/domain/usecases/get_cart_items_usecase.dart';
import 'features/cart/domain/usecases/remove_from_cart_usecase.dart';
import 'features/cart/domain/usecases/update_cart_item_usecase.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/wishlist/data/datasources/wishlist_local_data_source.dart';
import 'features/wishlist/data/models/wishlist_item_model.dart';
import 'features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'features/wishlist/domain/repositories/wishlist_repository.dart';
import 'features/wishlist/domain/usecases/add_to_wishlist_usecase.dart';
import 'features/wishlist/domain/usecases/get_wishlist_usecase.dart';
import 'features/wishlist/domain/usecases/remove_from_wishlist_usecase.dart';
import 'features/wishlist/presentation/bloc/wishlist_bloc.dart';
import 'features/orders/data/datasources/order_local_data_source.dart';
import 'features/orders/data/datasources/order_remote_data_source.dart';
import 'features/orders/data/models/order_model.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/orders/domain/repositories/order_repository.dart';
import 'features/orders/domain/usecases/create_order_usecase.dart';
import 'features/orders/domain/usecases/get_order_detail_usecase.dart';
import 'features/orders/domain/usecases/get_orders_usecase.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize all dependencies
/// This should be called before runApp() in main.dart
Future<void> init() async {
  //! Features

  // Authentication Feature
  // BLoCs
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(hiveService: sl()),
  );

  // Products Feature
  // BLoCs
  sl.registerFactory(
    () => ProductListBloc(
      getProductsUseCase: sl(),
      searchProductsUseCase: sl(),
      getCategoriesUseCase: sl(),
      getProductsByCategoryUseCase: sl(),
    ),
  );
  sl.registerFactory(() => ProductDetailBloc(getProductDetailUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailUseCase(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsByCategoryUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(hiveService: sl()),
  );

  // Cart Feature
  // BLoCs
  sl.registerFactory(
    () => CartBloc(
      getCartItemsUseCase: sl(),
      addToCartUseCase: sl(),
      updateCartItemUseCase: sl(),
      removeFromCartUseCase: sl(),
      clearCartUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetCartItemsUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(hiveService: sl()),
  );

  // Wishlist Feature
  // BLoCs
  sl.registerFactory(
    () => WishlistBloc(
      getWishlistUseCase: sl(),
      addToWishlistUseCase: sl(),
      removeFromWishlistUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetWishlistUseCase(sl()));
  sl.registerLazySingleton(() => AddToWishlistUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlistUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<WishlistLocalDataSource>(
    () => WishlistLocalDataSourceImpl(hiveService: sl()),
  );

  // Orders Feature
  // BLoCs
  sl.registerFactory(
    () => OrderBloc(
      getOrdersUseCase: sl(),
      createOrderUseCase: sl(),
      getOrderDetailUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateOrderUseCase(sl()));
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderDetailUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      authLocalDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<OrderLocalDataSource>(
    () => OrderLocalDataSourceImpl(hiveService: sl()),
  );

  //! Core

  // Network
  sl.registerLazySingleton<ApiClient>(() => ApiClient(dio: sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Storage
  sl.registerLazySingleton<HiveService>(() => HiveService());

  //! External

  // Dio HTTP client
  sl.registerLazySingleton<Dio>(() => Dio());

  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  //! Initialize Hive
  await sl<HiveService>().init();

  // Register Hive adapters
  sl<HiveService>().registerAdapter(UserModelAdapter());
  sl<HiveService>().registerAdapter(NameModelAdapter());
  sl<HiveService>().registerAdapter(AddressModelAdapter());
  sl<HiveService>().registerAdapter(GeolocationModelAdapter());
  sl<HiveService>().registerAdapter(ProductModelAdapter());
  sl<HiveService>().registerAdapter(RatingModelAdapter());
  sl<HiveService>().registerAdapter(CartItemModelAdapter());
  sl<HiveService>().registerAdapter(WishlistItemModelAdapter());
  sl<HiveService>().registerAdapter(OrderModelAdapter());
  sl<HiveService>().registerAdapter(OrderItemModelAdapter());
  sl<HiveService>().registerAdapter(OrderStatusModelAdapter());
}
