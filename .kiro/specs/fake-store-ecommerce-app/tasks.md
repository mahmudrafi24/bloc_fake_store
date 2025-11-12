# Implementation Plan

## Phase 1: Foundation Setup

- [x] 1. Set up project structure and core dependencies




  - [x] 1.1 Configure pubspec.yaml with all required dependencies


    - Add flutter_bloc, equatable for state management
    - Add get_it for dependency injection
    - Add go_router for navigation
    - Add hive, hive_flutter for local storage
    - Add dio, connectivity_plus for networking
    - Add dartz for functional programming
    - Add cached_network_image, intl for UI utilities
    - Add dev dependencies: hive_generator, build_runner, mockito, bloc_test
    - _Requirements: All requirements depend on proper dependency setup_
  
  - [x] 1.2 Create folder structure following Clean Architecture pattern


    - Create lib/core/ with subdirectories: constants/, errors/, network/, utils/, usecases/
    - Create lib/features/ directory for feature modules
    - Create lib/config/ for app configuration (theme, routes)
    - _Requirements: All requirements depend on proper project structure_
  
  - [x] 1.3 Implement core constants


    - Create lib/core/constants/api_constants.dart with FakeStoreAPI base URL and endpoints
    - Create lib/core/constants/app_colors.dart with color palette
    - Create lib/core/constants/app_strings.dart with text constants
    - Create lib/core/constants/app_text_styles.dart with typography
    - _Requirements: 2.1, 3.2, 9.1_

## Phase 2: Core Infrastructure

- [x] 2. Implement core utilities and error handling




  - [x] 2.1 Create failure classes and exception types


    - Create lib/core/errors/failures.dart with Failure base class
    - Implement ServerFailure, CacheFailure, NetworkFailure, ValidationFailure
    - Create lib/core/errors/exceptions.dart with custom exception classes
    - _Requirements: 9.1, 9.2_
  
  - [x] 2.2 Implement UseCase base class


    - Create lib/core/usecases/usecase.dart with abstract UseCase class
    - Define call method returning Either<Failure, T>
    - _Requirements: All use case requirements_
  
  - [x] 2.3 Create validators and formatters utilities


    - Create lib/core/utils/validators.dart with email, password, phone validators
    - Create lib/core/utils/formatters.dart with price and date formatters
    - _Requirements: 1.3, 9.5_
  

  - [x] 2.4 Implement extensions for common operations

    - Create lib/core/utils/extensions.dart with String, DateTime, BuildContext extensions
    - _Requirements: 7.3, 9.4_

-

- [x] 3. Set up network layer and local storage




  - [x] 3.1 Implement ApiClient with Dio


    - Create lib/core/network/api_client.dart with GET, POST, PUT, DELETE methods
    - Add request/response interceptors for authentication and logging
    - Configure base URL, timeouts, and headers
    - _Requirements: 2.1, 3.1, 1.1_
  
  - [x] 3.2 Implement NetworkInfo for connectivity checking


    - Create lib/core/network/network_info.dart interface
    - Implement NetworkInfoImpl using connectivity_plus
    - _Requirements: 8.2, 9.2_
  
  - [x] 3.3 Set up Hive local storage service


    - Create lib/core/storage/hive_service.dart for box management
    - Initialize Hive with Flutter in the service
    - Prepare for Hive adapter registration
    - _Requirements: 4.1, 5.1, 8.1, 8.4_

- [x] 4. Implement dependency injection with GetIt




  - [x] 4.1 Create injection_container.dart with service locator setup


    - Create lib/injection_container.dart with GetIt instance
    - Set up registration structure for BLoCs (factories), use cases (lazy singletons), repositories, data sources
    - Register core services (ApiClient, NetworkInfo, HiveService)
    - Initialize Hive during setup
    - _Requirements: All requirements depend on DI_

## Phase 3: Authentication Feature

- [x] 5. Implement authentication feature - Domain layer






  - [x] 5.1 Create User entity and related value objects

    - Create lib/features/authentication/domain/entities/user.dart
    - Implement User, Address, and Name classes
    - _Requirements: 1.1, 1.2, 1.3_
  

  - [x] 5.2 Create AuthRepository interface

    - Create lib/features/authentication/domain/repositories/auth_repository.dart
    - Define methods: login, register, logout, getCurrentUser
    - Return Either<Failure, T> for all methods
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_
  

  - [x] 5.3 Implement authentication use cases

    - Create lib/features/authentication/domain/usecases/ directory
    - Implement LoginUseCase, RegisterUseCase, LogoutUseCase, GetCurrentUserUseCase
    - Each use case extends UseCase base class and returns Either<Failure, T>
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_

- [x] 6. Implement authentication feature - Data layer






  - [x] 6.1 Create UserModel extending User entity

    - Create lib/features/authentication/data/models/user_model.dart
    - Implement fromJson and toJson methods
    - Add Hive type annotations and generate adapter with build_runner
    - _Requirements: 1.1, 1.2, 8.4_
  

  - [x] 6.2 Implement AuthRemoteDataSource

    - Create lib/features/authentication/data/datasources/auth_remote_data_source.dart
    - Implement interface and implementation class
    - Create methods for login API call (POST /auth/login)
    - Create methods for register API call (POST /users)
    - Handle API responses and errors
    - _Requirements: 1.1, 1.2_
  

  - [x] 6.3 Implement AuthLocalDataSource

    - Create lib/features/authentication/data/datasources/auth_local_data_source.dart
    - Implement interface and implementation class
    - Create methods to store/retrieve authentication token in Hive
    - Create methods to store/retrieve user data in Hive
    - Implement clear methods for logout
    - _Requirements: 1.2, 1.5, 8.4_

  
  - [x] 6.4 Implement AuthRepositoryImpl

    - Create lib/features/authentication/data/repositories/auth_repository_impl.dart
    - Coordinate between remote and local data sources
    - Implement caching strategy for user data
    - Handle network connectivity checks
    - Map exceptions to Failure types
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 8.4_

- [x] 7. Implement authentication feature - Presentation layer



  - [x] 7.1 Create AuthBloc with events and states


    - Create lib/features/authentication/presentation/bloc/ directory
    - Create auth_event.dart with events: LoginRequested, RegisterRequested, LogoutRequested, CheckAuthStatus
    - Create auth_state.dart with states: AuthInitial, AuthLoading, Authenticated, Unauthenticated, AuthError
    - Create auth_bloc.dart implementing event handlers calling use cases
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5_
  
  - [x] 7.2 Create LoginPage with login form


    - Create lib/features/authentication/presentation/pages/login_page.dart
    - Build UI with email and password fields
    - Add form validation
    - Connect to AuthBloc for login action
    - Show loading indicators and error messages
    - Navigate to products page on success
    - _Requirements: 1.1, 1.4, 9.3, 9.4, 9.5_
  
  - [x] 7.3 Create RegisterPage with registration form


    - Create lib/features/authentication/presentation/pages/register_page.dart
    - Build UI with username, email, password, and address fields
    - Add form validation
    - Connect to AuthBloc for registration action
    - Show loading indicators and error messages
    - _Requirements: 1.3, 9.3, 9.4, 9.5_
  
  - [x] 7.4 Create ProfilePage to display user info


    - Create lib/features/authentication/presentation/pages/profile_page.dart
    - Show user details (username, email, address)
    - Add logout button
    - Connect to AuthBloc for logout action
    - _Requirements: 1.5_

## Phase 4: Products Feature

- [x] 8. Implement products feature - Domain layer





  - [x] 8.1 Create Product and Category entities


    - Create lib/features/products/domain/entities/product.dart
    - Implement Product class with all properties (id, title, price, description, category, image, rating)
    - Create Rating value object
    - _Requirements: 2.1, 2.2, 3.2_
  
  - [x] 8.2 Create ProductRepository interface


    - Create lib/features/products/domain/repositories/product_repository.dart
    - Define methods: getProducts, getProductById, searchProducts, getCategories, getProductsByCategory
    - Return Either<Failure, T> for all methods
    - _Requirements: 2.1, 2.2, 2.3, 3.1_
  
  - [x] 8.3 Implement product use cases


    - Create lib/features/products/domain/usecases/ directory
    - Implement GetProductsUseCase, GetProductDetailUseCase, SearchProductsUseCase, GetCategoriesUseCase
    - Each use case extends UseCase base class and returns Either<Failure, T>
    - _Requirements: 2.1, 2.2, 2.3, 3.1_

- [x] 9. Implement products feature - Data layer




  - [x] 9.1 Create ProductModel and CategoryModel


    - Create lib/features/products/data/models/product_model.dart
    - Implement fromJson and toJson methods
    - Add Hive type annotations and generate adapter with build_runner
    - _Requirements: 2.1, 3.2, 8.1_
  
  - [x] 9.2 Implement ProductRemoteDataSource


    - Create lib/features/products/data/datasources/product_remote_data_source.dart
    - Implement interface and implementation class
    - Create method for GET /products (all products)
    - Create method for GET /products/{id} (single product)
    - Create method for GET /products/categories (categories list)
    - Handle API responses and errors
    - _Requirements: 2.1, 2.3, 3.1_
  
  - [x] 9.3 Implement ProductLocalDataSource


    - Create lib/features/products/data/datasources/product_local_data_source.dart
    - Implement interface and implementation class
    - Create methods to cache products in Hive
    - Implement cache expiration logic (1 hour)
    - Create methods to retrieve cached products
    - _Requirements: 8.1, 8.2_
  
  - [x] 9.4 Implement ProductRepositoryImpl


    - Create lib/features/products/data/repositories/product_repository_impl.dart
    - Coordinate between remote and local data sources
    - Implement cache-first strategy with background refresh
    - Handle offline scenarios by serving from cache
    - Implement search functionality by filtering cached products
    - Map exceptions to Failure types
    - _Requirements: 2.1, 2.2, 2.3, 3.1, 3.5, 8.1, 8.2, 8.5_

- [x] 10. Implement products feature - Presentation layer




  - [x] 10.1 Create ProductListBloc with events and states


    - Create lib/features/products/presentation/bloc/product_list/ directory
    - Create product_list_event.dart with events: LoadProducts, SearchProducts, FilterByCategory, RefreshProducts
    - Create product_list_state.dart with states: ProductListInitial, ProductListLoading, ProductListLoaded, ProductListError
    - Create product_list_bloc.dart implementing event handlers calling use cases
    - _Requirements: 2.1, 2.2, 2.3, 2.5_


  
  - [x] 10.2 Create ProductDetailBloc with events and states




    - Create lib/features/products/presentation/bloc/product_detail/ directory
    - Create product_detail_event.dart with events: LoadProductDetail
    - Create product_detail_state.dart with states: ProductDetailInitial, ProductDetailLoading, ProductDetailLoaded, ProductDetailError


    - Create product_detail_bloc.dart implementing event handler calling GetProductDetailUseCase
    - _Requirements: 3.1, 3.2, 3.5_
  
  - [x] 10.3 Create ProductCard widget





    - Create lib/features/products/presentation/widgets/product_card.dart
    - Display product image, title, price, and rating


    - Make card tappable to navigate to detail page
    - Add wishlist icon button
    - Make responsive for different screen sizes
    - _Requirements: 2.4, 7.1_
  



-

  - [x] 10.4 Create ProductGrid widget with responsive layout







    - Create lib/features/products/presentation/widgets/product_grid.dart
    - Use GridView.builder for product list
    - Implement responsive columns (2 mobile, 3 tablet, 4 desktop)


    - Use LayoutBuilder to determine screen size
    - _Requirements: 2.1, 7.1_
  
  - [x] 10.5 Create CategoryFilter widget





    - Create lib/features/products/presentation/widgets/category_filter.dart
    - Display category chips for filtering
    - Connect to ProductListBloc for filter action
    - _Requirements: 2.3_


  
  - [x] 10.6 Create ProductsPage with product grid and filters





    - Create lib/features/products/presentation/pages/products_page.dart
    - Build app bar with search icon
    - Display CategoryFilter widget
    - Display ProductGrid with products from ProductListBloc


    - Show loading indicator while fetching
    - Show error message with retry button on failure
    - Implement pull-to-refresh
    - _Requirements: 2.1, 2.2, 2.3, 2.5, 9.1, 9.2, 9.3_
  
  - [x] 10.7 Create SearchPage with search functionality





    - Create lib/features/products/presentation/pages/search_page.dart
    - Build search bar with text input
    - Display search results using ProductGrid
    - Connect to ProductListBloc for search action
    - Show empty state when no results
    - _Requirements: 2.2, 9.3_
  
  - [x] 10.8 Create ProductDetailPage





    - Create lib/features/products/presentation/pages/product_detail_page.dart
    - Display large product image with cached_network_image
    - Show product title, price, description, category, and rating
    - Add "Add to Cart" button connected to CartBloc
    - Add wishlist toggle button connected to WishlistBloc
    - Show loading indicator while fetching
    - Show error message with retry button on failure
    - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5, 9.1, 9.2_

## Phase 5: Cart Feature

- [x] 11. Implement cart feature - Domain layer





  - [x] 11.1 Create CartItem entity


    - Create lib/features/cart/domain/entities/cart_item.dart
    - Implement CartItem class with product, quantity, and subtotal
    - _Requirements: 4.1, 4.2_
  
  - [x] 11.2 Create CartRepository interface


    - Create lib/features/cart/domain/repositories/cart_repository.dart
    - Define methods: getCartItems, addToCart, updateCartItem, removeFromCart, clearCart, watchCartCount
    - Return Either<Failure, T> for all methods
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_


  
  - [x] 11.3 Implement cart use cases





    - Create lib/features/cart/domain/usecases/ directory
    - Implement GetCartItemsUseCase, AddToCartUseCase, UpdateCartItemUseCase, RemoveFromCartUseCase, ClearCartUseCase
    - Each use case extends UseCase base class and returns Either<Failure, T>
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [x] 12. Implement cart feature - Data layer




  - [x] 12.1 Create CartItemModel


    - Create lib/features/cart/data/models/cart_item_model.dart
    - Implement fromJson and toJson methods
    - Add Hive type annotations and generate adapter with build_runner
    - _Requirements: 4.1, 8.4_
  
  - [x] 12.2 Implement CartLocalDataSource


    - Create lib/features/cart/data/datasources/cart_local_data_source.dart
    - Implement interface and implementation class
    - Create methods to store/retrieve cart items in Hive
    - Implement add, update, remove, and clear operations
    - Create stream for cart count updates
    - Calculate totals on-the-fly
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_
  
  - [x] 12.3 Implement CartRepositoryImpl


    - Create lib/features/cart/data/repositories/cart_repository_impl.dart
    - Delegate all operations to local data source
    - Map exceptions to Failure types
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_

- [x] 13. Implement cart feature - Presentation layer




  - [x] 13.1 Create CartBloc with events and states


    - Create lib/features/cart/presentation/bloc/ directory
    - Create cart_event.dart with events: LoadCart, AddToCart, UpdateQuantity, RemoveItem, ClearCart
    - Create cart_state.dart with states: CartInitial, CartLoading, CartLoaded, CartError
    - Create cart_bloc.dart implementing event handlers calling use cases
    - Maintain cart count in state
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5_
  


  - [x] 13.2 Create CartItemWidget

    - Create lib/features/cart/presentation/widgets/cart_item_widget.dart
    - Display product image, title, and price
    - Add quantity controls (increment/decrement buttons)
    - Add remove button
    - Connect to CartBloc for update and remove actions


    - _Requirements: 4.2, 4.3_
  

  - [x] 13.3 Create CartSummary widget


    - Create lib/features/cart/presentation/widgets/cart_summary.dart

    - Display total items count and total price
    - Add "Proceed to Checkout" button
    - _Requirements: 4.4_
  
  - [x] 13.4 Create CartPage

    - Create lib/features/cart/presentation/pages/cart_page.dart
    - Display list of cart items using CartItemWidget
    - Show CartSummary at bottom
    - Show empty state when cart is empty
    - Connect to CartBloc for cart data
    - Navigate to checkout on button press
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 9.3_

## Phase 6: Wishlist Feature

- [x] 14. Implement wishlist feature - Domain layer





  - [x] 14.1 Create WishlistItem entity


    - Create lib/features/wishlist/domain/entities/wishlist_item.dart
    - Implement WishlistItem class with product and addedAt timestamp
    - _Requirements: 5.1, 5.2_
  
  - [x] 14.2 Create WishlistRepository interface


    - Create lib/features/wishlist/domain/repositories/wishlist_repository.dart
    - Define methods: getWishlistItems, addToWishlist, removeFromWishlist, isInWishlist
    - Return Either<Failure, T> for all methods
    - _Requirements: 5.1, 5.2, 5.3_
  
  - [x] 14.3 Implement wishlist use cases


    - Create lib/features/wishlist/domain/usecases/ directory
    - Implement GetWishlistUseCase, AddToWishlistUseCase, RemoveFromWishlistUseCase
    - Each use case extends UseCase base class and returns Either<Failure, T>
    - _Requirements: 5.1, 5.2, 5.3_

- [x] 15. Implement wishlist feature - Data layer





  - [x] 15.1 Create WishlistItemModel


    - Create lib/features/wishlist/data/models/wishlist_item_model.dart
    - Implement fromJson and toJson methods
    - Add Hive type annotations and generate adapter with build_runner
    - _Requirements: 5.1, 8.4_
  
  - [x] 15.2 Implement WishlistLocalDataSource


    - Create lib/features/wishlist/data/datasources/wishlist_local_data_source.dart
    - Implement interface and implementation class
    - Create methods to store/retrieve wishlist items in Hive
    - Implement add, remove, and check operations
    - _Requirements: 5.1, 5.2_
  
  - [x] 15.3 Implement WishlistRepositoryImpl


    - Create lib/features/wishlist/data/repositories/wishlist_repository_impl.dart
    - Delegate all operations to local data source
    - Map exceptions to Failure types
    - _Requirements: 5.1, 5.2, 5.3_

- [x] 16. Implement wishlist feature - Presentation layer





  - [x] 16.1 Create WishlistBloc with events and states


    - Create lib/features/wishlist/presentation/bloc/ directory
    - Create wishlist_event.dart with events: LoadWishlist, AddToWishlist, RemoveFromWishlist, CheckWishlistStatus
    - Create wishlist_state.dart with states: WishlistInitial, WishlistLoading, WishlistLoaded, WishlistError
    - Create wishlist_bloc.dart implementing event handlers calling use cases
    - _Requirements: 5.1, 5.2, 5.3_
  
  - [x] 16.2 Create WishlistItemWidget


    - Create lib/features/wishlist/presentation/widgets/wishlist_item_widget.dart
    - Display product image, title, and price
    - Add remove button
    - Add "Add to Cart" button
    - Connect to WishlistBloc and CartBloc
    - _Requirements: 5.3, 5.5_
  
  - [x] 16.3 Create WishlistPage


    - Create lib/features/wishlist/presentation/pages/wishlist_page.dart
    - Display grid of wishlist items using WishlistItemWidget
    - Use responsive grid layout
    - Show empty state when wishlist is empty
    - Connect to WishlistBloc for wishlist data
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

## Phase 7: Orders Feature

- [x] 17. Implement orders feature - Domain layer






  - [x] 17.1 Create Order and OrderItem entities

    - Create lib/features/orders/domain/entities/order.dart
    - Implement Order class with items, total, date, status, and address
    - Create OrderStatus enum
    - Implement OrderItem class
    - _Requirements: 6.2, 6.4_
  
  - [x] 17.2 Create OrderRepository interface


    - Create lib/features/orders/domain/repositories/order_repository.dart
    - Define methods: createOrder, getOrders, getOrderById
    - Return Either<Failure, T> for all methods
    - _Requirements: 6.2, 6.4, 6.5_
  
  - [x] 17.3 Implement order use cases


    - Create lib/features/orders/domain/usecases/ directory
    - Implement CreateOrderUseCase, GetOrdersUseCase, GetOrderDetailUseCase
    - Each use case extends UseCase base class and returns Either<Failure, T>
    - _Requirements: 6.2, 6.4, 6.5_

- [x] 18. Implement orders feature - Data layer




  - [x] 18.1 Create OrderModel and OrderItemModel


    - Create lib/features/orders/data/models/order_model.dart
    - Implement fromJson and toJson methods
    - Add Hive type annotations and generate adapter with build_runner
    - _Requirements: 6.2, 8.4_
  
  - [x] 18.2 Implement OrderRemoteDataSource


    - Create lib/features/orders/data/datasources/order_remote_data_source.dart
    - Implement interface and implementation class
    - Create method for POST /carts (simulate order creation)
    - Handle API responses and errors
    - _Requirements: 6.2_
  
  - [x] 18.3 Implement OrderLocalDataSource


    - Create lib/features/orders/data/datasources/order_local_data_source.dart
    - Implement interface and implementation class
    - Create methods to store/retrieve orders in Hive
    - _Requirements: 6.3, 8.4_
  
  - [x] 18.4 Implement OrderRepositoryImpl


    - Create lib/features/orders/data/repositories/order_repository_impl.dart
    - Coordinate between remote and local data sources
    - Store orders locally after creation
    - Map exceptions to Failure types
    - _Requirements: 6.2, 6.3, 6.4, 6.5_
- [x] 19. Implement orders feature - Presentation layer



- [ ] 19. Implement orders feature - Presentation layer

  - [x] 19.1 Create OrderBloc with events and states


    - Create lib/features/orders/presentation/bloc/ directory
    - Create order_event.dart with events: LoadOrders, CreateOrder, LoadOrderDetail
    - Create order_state.dart with states: OrderInitial, OrderLoading, OrdersLoaded, OrderCreated, OrderError
    - Create order_bloc.dart implementing event handlers calling use cases
    - _Requirements: 6.2, 6.4, 6.5_
  
  - [x] 19.2 Create CheckoutForm widget


    - Create lib/features/orders/presentation/widgets/checkout_form.dart
    - Build form with address fields (street, city, zipcode)
    - Add form validation
    - _Requirements: 6.1_
  
  - [x] 19.3 Create CheckoutPage


    - Create lib/features/orders/presentation/pages/checkout_page.dart
    - Display cart summary
    - Show CheckoutForm for shipping address
    - Add "Place Order" button
    - Connect to OrderBloc for order creation
    - Clear cart after successful order
    - Navigate to orders page on success
    - _Requirements: 6.1, 6.2, 9.3, 9.4_
  
  - [x] 19.4 Create OrderCard widget


    - Create lib/features/orders/presentation/widgets/order_card.dart
    - Display order ID, date, status, and total amount
    - Make card tappable to navigate to order detail
    - _Requirements: 6.4_
  
  - [x] 19.5 Create OrdersPage


    - Create lib/features/orders/presentation/pages/orders_page.dart
    - Display list of orders using OrderCard
    - Connect to OrderBloc for orders data
    - Show empty state when no orders
    - _Requirements: 6.4_
  
  - [x] 19.6 Create OrderDetailPage


    - Create lib/features/orders/presentation/pages/order_detail_page.dart
    - Display order information (ID, date, status, address)
    - Show list of order items with product details
    - Display total amount
    - Connect to OrderBloc for order detail
    - _Requirements: 6.5_

## Phase 8: Theme, Navigation & App Integration

- [x] 20. Implement app theme and responsive utilities




  - [x] 20.1 Create AppTheme with light and dark themes


    - Create lib/config/theme/app_theme.dart
    - Define color schemes, text themes, and component themes
    - Use app_colors and app_text_styles constants
    - _Requirements: 7.3_
  
  - [x] 20.2 Create responsive utility classes


    - Create lib/core/utils/responsive.dart
    - Implement Breakpoints class with mobile, tablet, desktop values
    - Create ResponsiveBuilder widget for conditional rendering
    - Create responsive padding and spacing utilities
    - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5_

- [x] 21. Implement navigation with GoRouter




  - [x] 21.1 Create router configuration with all routes


    - Create lib/config/routes/app_router.dart
    - Define routes for all pages (products, product detail, cart, wishlist, orders, order detail, checkout, profile, login, register)
    - Implement route parameters for detail pages
    - Add redirect logic for authentication
    - _Requirements: 1.4, 2.4, 5.4, 6.5, 10.1, 10.2, 10.3, 10.4, 10.5_
  


  - [x] 21.2 Implement navigation widgets





    - Create lib/core/widgets/navigation/ directory
    - Create bottom_nav_bar.dart for mobile navigation
    - Create nav_rail.dart for tablet and desktop navigation
    - Use ResponsiveBuilder to switch between navigation types
    - Add cart badge showing item count
    - _Requirements: 7.2, 10.1, 10.3_

- [x] 22. Wire up main.dart and complete app integration






  - [x] 22.1 Initialize dependency injection in main.dart


    - Update lib/main.dart to call injection_container init() before runApp
    - Handle async initialization properly
    - _Requirements: All requirements_


  
  - [x] 22.2 Set up MaterialApp with GoRouter and theme





    - Configure MaterialApp.router with GoRouter
    - Apply AppTheme


    - Set up BlocProviders for global BLoCs (AuthBloc, CartBloc)
    - _Requirements: All requirements_
  
  - [x] 22.3 Implement splash screen with auth check



    - Create lib/core/widgets/splash_screen.dart
    - Check authentication status on app start
    - Navigate to products page if authenticated, login page otherwise
    - _Requirements: 1.4, 8.5_

## Phase 9: Error Handling & Common Widgets

- [x] 23. Add error handling and loading states across the app







  - [ ] 23.1 Create reusable error and loading widgets
    - Create lib/core/widgets/error_widget.dart with retry button
    - Create lib/core/widgets/loading_widget.dart with spinner
    - Create lib/core/widgets/empty_state_widget.dart for empty lists


    - _Requirements: 9.1, 9.2, 9.3_
  
  - [ ] 23.2 Integrate error handling in all BLoC listeners
    - Review all pages and add BlocListener for error states
    - Show SnackBars for errors in all pages
    - Implement retry mechanisms where appropriate
    - _Requirements: 9.1, 9.2, 9.4_

## Phase 10: Testing (Optional)

- [ ]* 24. Implement testing
  - [ ]* 24.1 Write unit tests for use cases
    - Create test files in test/features/*/domain/usecases/
    - Test all use cases with mocked repositories
    - _Requirements: All requirements_
  
  - [ ]* 24.2 Write unit tests for repositories
    - Create test files in test/features/*/data/repositories/
    - Test repository implementations with mocked data sources
    - _Requirements: All requirements_
  
  - [ ]* 24.3 Write unit tests for BLoCs
    - Create test files in test/features/*/presentation/bloc/
    - Test BLoC logic with mocked use cases using bloc_test
    - _Requirements: All requirements_
  
  - [ ]* 24.4 Write widget tests for key widgets
    - Create test files in test/features/*/presentation/widgets/
    - Test ProductCard, CartItemWidget, and other reusable widgets
    - _Requirements: All requirements_
  
  - [ ]* 24.5 Write integration tests for critical flows
    - Create integration_test/ directory
    - Test login → browse → add to cart → checkout flow
    - Test offline scenarios
    - _Requirements: 1.1, 2.1, 4.1, 6.2, 8.2_

## Phase 11: Polish & Optimization (Optional)

- [ ]* 25. Polish and optimization
  - [ ]* 25.1 Optimize image loading with cached_network_image
    - Review all product image usages
    - Add placeholders and error widgets for all product images
    - Configure cache settings
    - _Requirements: 3.2_
  
  - [ ]* 25.2 Implement pagination for product lists
    - Add load more functionality to ProductsPage
    - Show loading indicator at bottom while loading more
    - _Requirements: 2.1_
  
  - [ ]* 25.3 Add pull-to-refresh on all list pages
    - Implement RefreshIndicator on ProductsPage, CartPage, WishlistPage, OrdersPage
    - _Requirements: 2.1, 4.1, 5.1, 6.4_
  
  - [ ]* 25.4 Optimize BLoC performance
    - Review all BlocBuilder and BlocListener usages
    - Add buildWhen and listenWhen to optimize rebuilds
    - Ensure proper BLoC disposal
    - _Requirements: All requirements_
  
  - [ ]* 25.5 Add animations and transitions
    - Implement page transitions in GoRouter
    - Add subtle animations to buttons and cards
    - _Requirements: 9.4_
