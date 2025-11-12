# Design Document

## Overview

The FakeStore e-commerce application is built using Flutter with Clean Architecture principles, ensuring separation of concerns, testability, and maintainability. The architecture consists of three main layers: Presentation (UI + BLoC), Domain (business logic), and Data (repositories + data sources). The app uses BLoC for state management, Hive for local persistence, GetIt for dependency injection, and GoRouter for navigation.

## Architecture

### Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Pages      │  │    BLoCs     │  │   Widgets    │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                           ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Entities   │  │  Use Cases   │  │ Repositories │      │
│  │              │  │              │  │ (Interfaces) │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
                           ↓ ↑
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Models     │  │ Repositories │  │ Data Sources │      │
│  │              │  │    (Impl)    │  │ Remote/Local │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└─────────────────────────────────────────────────────────────┘
```

### Dependency Flow

- Presentation depends on Domain
- Domain is independent (core business logic)
- Data depends on Domain
- Dependencies are injected using GetIt service locator

## Components and Interfaces

### 1. Core Components

#### API Client
```dart
class ApiClient {
  final Dio dio;
  
  Future<Response> get(String path);
  Future<Response> post(String path, dynamic data);
  Future<Response> put(String path, dynamic data);
  Future<Response> delete(String path);
}
```

**Responsibilities:**
- HTTP communication with FakeStoreAPI
- Request/response interceptors for authentication
- Error handling and timeout management
- Base URL configuration

#### Network Info
```dart
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
```

**Responsibilities:**
- Check internet connectivity
- Used by repositories to determine online/offline behavior

#### Local Storage (Hive)
```dart
class HiveService {
  Future<void> init();
  Box<T> getBox<T>(String boxName);
  Future<void> clearAll();
}
```

**Responsibilities:**
- Initialize Hive database
- Provide access to typed boxes
- Manage database lifecycle

### 2. Feature: Authentication

#### Domain Layer

**Entity:**
```dart
class User {
  final int id;
  final String username;
  final String email;
  final String? token;
  final Address? address;
  final Name? name;
  final String? phone;
}
```

**Repository Interface:**
```dart
abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, User>> register(UserRegistration registration);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
}
```

**Use Cases:**
- `LoginUseCase`: Authenticate user with credentials
- `RegisterUseCase`: Create new user account
- `LogoutUseCase`: Clear authentication state
- `GetCurrentUserUseCase`: Retrieve authenticated user info

#### Data Layer

**Model:**
```dart
class UserModel extends User {
  factory UserModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

**Data Sources:**
- `AuthRemoteDataSource`: API calls to /auth/login and /users
- `AuthLocalDataSource`: Store/retrieve token and user data in Hive

**Repository Implementation:**
- Coordinates between remote and local data sources
- Implements caching strategy
- Handles offline scenarios

#### Presentation Layer

**BLoC:**
```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Events: LoginRequested, RegisterRequested, LogoutRequested, CheckAuthStatus
  // States: AuthInitial, AuthLoading, Authenticated, Unauthenticated, AuthError
}
```

**Pages:**
- `LoginPage`: Login form with email/password
- `RegisterPage`: Registration form
- `ProfilePage`: Display user information and logout

### 3. Feature: Products

#### Domain Layer

**Entities:**
```dart
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;
}

class Category {
  final String name;
  final int productCount;
}
```

**Repository Interface:**
```dart
abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProductById(int id);
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  Future<Either<Failure, List<String>>> getCategories();
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
}
```

**Use Cases:**
- `GetProductsUseCase`: Fetch all products
- `GetProductDetailUseCase`: Fetch single product
- `SearchProductsUseCase`: Search products by query
- `GetCategoriesUseCase`: Fetch available categories

#### Data Layer

**Data Sources:**
- `ProductRemoteDataSource`: API calls to /products endpoints
- `ProductLocalDataSource`: Cache products in Hive

**Caching Strategy:**
- Cache products for 1 hour
- Serve from cache when offline
- Background refresh when online

#### Presentation Layer

**BLoCs:**
- `ProductListBloc`: Manages product list, filtering, and search
- `ProductDetailBloc`: Manages single product details

**Pages:**
- `ProductsPage`: Grid/list view of products with filters
- `ProductDetailPage`: Detailed product view
- `SearchPage`: Search interface with results

**Widgets:**
- `ProductCard`: Reusable product card component
- `ProductGrid`: Responsive grid layout
- `CategoryFilter`: Category selection chips

### 4. Feature: Cart

#### Domain Layer

**Entity:**
```dart
class CartItem {
  final int id;
  final Product product;
  final int quantity;
  final double subtotal;
}
```

**Repository Interface:**
```dart
abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addToCart(Product product, int quantity);
  Future<Either<Failure, void>> updateCartItem(int productId, int quantity);
  Future<Either<Failure, void>> removeFromCart(int productId);
  Future<Either<Failure, void>> clearCart();
  Stream<int> watchCartCount();
}
```

**Use Cases:**
- `GetCartItemsUseCase`: Retrieve all cart items
- `AddToCartUseCase`: Add product to cart
- `UpdateCartItemUseCase`: Update item quantity
- `RemoveFromCartUseCase`: Remove item from cart
- `ClearCartUseCase`: Empty the cart

#### Data Layer

**Data Source:**
- `CartLocalDataSource`: Hive-based cart storage
- No remote data source (cart is local-only)

**Storage Strategy:**
- Store cart items in Hive box
- Calculate totals on-the-fly
- Persist across app restarts

#### Presentation Layer

**BLoC:**
```dart
class CartBloc extends Bloc<CartEvent, CartState> {
  // Events: LoadCart, AddToCart, UpdateQuantity, RemoveItem, ClearCart
  // States: CartInitial, CartLoading, CartLoaded, CartError
}
```

**Pages:**
- `CartPage`: List of cart items with totals

**Widgets:**
- `CartItemWidget`: Individual cart item with quantity controls
- `CartSummary`: Total price and checkout button

### 5. Feature: Wishlist

#### Domain Layer

**Entity:**
```dart
class WishlistItem {
  final int id;
  final Product product;
  final DateTime addedAt;
}
```

**Repository Interface:**
```dart
abstract class WishlistRepository {
  Future<Either<Failure, List<WishlistItem>>> getWishlistItems();
  Future<Either<Failure, void>> addToWishlist(Product product);
  Future<Either<Failure, void>> removeFromWishlist(int productId);
  Future<Either<Failure, bool>> isInWishlist(int productId);
}
```

#### Data Layer

**Data Source:**
- `WishlistLocalDataSource`: Hive-based wishlist storage

#### Presentation Layer

**BLoC:**
```dart
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  // Events: LoadWishlist, AddToWishlist, RemoveFromWishlist, CheckWishlistStatus
  // States: WishlistInitial, WishlistLoading, WishlistLoaded, WishlistError
}
```

**Pages:**
- `WishlistPage`: Grid of wishlist items

**Widgets:**
- `WishlistItemWidget`: Wishlist item card with remove button

### 6. Feature: Orders

#### Domain Layer

**Entity:**
```dart
class Order {
  final int id;
  final int userId;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status;
  final Address shippingAddress;
}

class OrderItem {
  final Product product;
  final int quantity;
  final double price;
}

enum OrderStatus { pending, processing, shipped, delivered, cancelled }
```

**Repository Interface:**
```dart
abstract class OrderRepository {
  Future<Either<Failure, Order>> createOrder(List<CartItem> items, Address address);
  Future<Either<Failure, List<Order>>> getOrders();
  Future<Either<Failure, Order>> getOrderById(int id);
}
```

**Use Cases:**
- `CreateOrderUseCase`: Create order from cart
- `GetOrdersUseCase`: Fetch user orders
- `GetOrderDetailUseCase`: Fetch single order

#### Data Layer

**Data Sources:**
- `OrderRemoteDataSource`: API calls to /carts endpoints (simulated orders)
- `OrderLocalDataSource`: Store orders in Hive

#### Presentation Layer

**BLoC:**
```dart
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  // Events: LoadOrders, CreateOrder, LoadOrderDetail
  // States: OrderInitial, OrderLoading, OrdersLoaded, OrderCreated, OrderError
}
```

**Pages:**
- `CheckoutPage`: Order confirmation and address form
- `OrdersPage`: List of user orders
- `OrderDetailPage`: Detailed order view

**Widgets:**
- `OrderCard`: Order summary card
- `CheckoutForm`: Address and payment form

## Data Models

### Product Model
```dart
class ProductModel extends Product {
  ProductModel({
    required int id,
    required String title,
    required double price,
    required String description,
    required String category,
    required String image,
    Rating? rating,
  }) : super(
    id: id,
    title: title,
    price: price,
    description: description,
    category: category,
    image: image,
    rating: rating,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating != null ? (rating as RatingModel).toJson() : null,
    };
  }
}
```

### Hive Adapters
```dart
@HiveType(typeId: 0)
class ProductModel extends Product {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  // ... other fields
}
```

**Type IDs:**
- 0: ProductModel
- 1: UserModel
- 2: CartItemModel
- 3: WishlistItemModel
- 4: OrderModel

## Responsive Design Strategy

### Breakpoints
```dart
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}
```

### Layout Adaptation

**Product Grid:**
- Mobile (< 600px): 2 columns
- Tablet (600-1200px): 3 columns
- Desktop (> 1200px): 4 columns

**Navigation:**
- Mobile: Bottom navigation bar
- Tablet/Desktop: Side navigation drawer or rail

**Spacing and Typography:**
- Use responsive padding/margin utilities
- Scale text sizes based on screen width
- Adjust image sizes proportionally

### Responsive Utilities
```dart
class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Breakpoints.desktop) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= Breakpoints.tablet) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}
```

## Navigation and Routing

### GoRouter Configuration
```dart
final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final isAuthenticated = authState is Authenticated;
    final isAuthRoute = state.location.startsWith('/auth');
    
    if (!isAuthenticated && !isAuthRoute) {
      return '/auth/login';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => ProductsPage(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (context, state) => RegisterPage(),
    ),
    GoRoute(
      path: '/products/:id',
      builder: (context, state) {
        final id = int.parse(state.params['id']!);
        return ProductDetailPage(productId: id);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => CartPage(),
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => WishlistPage(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => OrdersPage(),
    ),
    GoRoute(
      path: '/orders/:id',
      builder: (context, state) {
        final id = int.parse(state.params['id']!);
        return OrderDetailPage(orderId: id);
      },
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => CheckoutPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => ProfilePage(),
    ),
  ],
);
```

## Dependency Injection

### GetIt Setup
```dart
final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), logoutUseCase: sl()));
  sl.registerFactory(() => ProductListBloc(getProductsUseCase: sl()));
  sl.registerFactory(() => CartBloc(getCartItemsUseCase: sl()));
  
  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  
  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl())
  );
  
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl())
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(hiveService: sl())
  );
  
  // Core
  sl.registerLazySingleton(() => ApiClient(dio: sl()));
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => HiveService());
  
  // Initialize Hive
  await sl<HiveService>().init();
}
```

## Error Handling

### Failure Types
```dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}

class ValidationFailure extends Failure {
  ValidationFailure(String message) : super(message);
}
```

### Error Handling Strategy

1. **Repository Level:**
   - Wrap API calls in try-catch blocks
   - Return `Either<Failure, Success>` from all repository methods
   - Map exceptions to appropriate Failure types

2. **BLoC Level:**
   - Handle failures in event handlers
   - Emit error states with user-friendly messages
   - Provide retry mechanisms

3. **UI Level:**
   - Display error messages using SnackBars or dialogs
   - Show retry buttons for recoverable errors
   - Provide fallback UI for error states

### Exception Mapping
```dart
Failure _handleException(Exception e) {
  if (e is DioException) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return NetworkFailure('Connection timeout');
    } else if (e.response?.statusCode == 401) {
      return ServerFailure('Unauthorized');
    }
    return ServerFailure('Server error');
  } else if (e is HiveError) {
    return CacheFailure('Local storage error');
  }
  return ServerFailure('Unexpected error');
}
```

## Testing Strategy

### Unit Tests
- Test all use cases with mocked repositories
- Test repository implementations with mocked data sources
- Test BLoC logic with mocked use cases
- Test data models serialization/deserialization

### Widget Tests
- Test individual widgets in isolation
- Test widget interactions and state changes
- Test responsive layouts at different screen sizes

### Integration Tests
- Test complete user flows (login → browse → add to cart → checkout)
- Test offline scenarios
- Test navigation flows

### Test Structure
```
test/
├── core/
│   ├── network/
│   └── utils/
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── products/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── fixtures/
    └── test_data.json
```

## Performance Considerations

1. **Image Loading:**
   - Use `cached_network_image` for product images
   - Implement placeholder and error widgets
   - Optimize image sizes for different screen densities

2. **List Performance:**
   - Use `ListView.builder` for large lists
   - Implement pagination for product lists
   - Use `const` constructors where possible

3. **State Management:**
   - Minimize BLoC rebuilds with `buildWhen` and `listenWhen`
   - Use `Equatable` for state and event classes
   - Dispose BLoCs properly to prevent memory leaks

4. **Caching:**
   - Cache API responses with expiration
   - Implement cache invalidation strategies
   - Use Hive lazy boxes for large datasets

## Security Considerations

1. **Authentication:**
   - Store tokens securely in Hive encrypted box
   - Implement token refresh mechanism
   - Clear sensitive data on logout

2. **API Communication:**
   - Use HTTPS for all API calls
   - Validate SSL certificates
   - Implement request/response logging for debugging

3. **Input Validation:**
   - Validate all user inputs before submission
   - Sanitize data before storage
   - Implement proper error messages without exposing sensitive info

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  
  # Dependency Injection
  get_it: ^7.6.4
  
  # Navigation
  go_router: ^12.1.1
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Network
  dio: ^5.4.0
  connectivity_plus: ^5.0.2
  
  # Functional Programming
  dartz: ^0.10.1
  
  # UI
  cached_network_image: ^3.3.0
  flutter_svg: ^2.0.9
  
  # Utilities
  intl: ^0.18.1
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  hive_generator: ^2.0.1
  build_runner: ^2.4.7
  
  # Testing
  mockito: ^5.4.4
  bloc_test: ^9.1.5
```

## Implementation Phases

1. **Phase 1: Core Setup**
   - Project structure and dependencies
   - Core utilities and constants
   - Dependency injection setup
   - API client configuration

2. **Phase 2: Authentication**
   - User entity and models
   - Auth repository and data sources
   - Auth BLoC and use cases
   - Login and register pages

3. **Phase 3: Products**
   - Product entities and models
   - Product repository and data sources
   - Product BLoCs
   - Product listing and detail pages

4. **Phase 4: Cart & Wishlist**
   - Cart and wishlist entities
   - Local storage implementation
   - Cart and wishlist BLoCs
   - Cart and wishlist pages

5. **Phase 5: Orders**
   - Order entities and models
   - Order repository
   - Order BLoC
   - Checkout and order pages

6. **Phase 6: Polish**
   - Responsive design refinements
   - Error handling improvements
   - Performance optimization
   - Testing
