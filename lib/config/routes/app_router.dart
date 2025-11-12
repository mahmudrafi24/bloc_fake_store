import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentication/presentation/bloc/auth_bloc.dart';
import '../../features/authentication/presentation/bloc/auth_state.dart';
import '../../features/authentication/presentation/pages/login_page.dart';
import '../../features/authentication/presentation/pages/register_page.dart';
import '../../features/authentication/presentation/pages/profile_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/search_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/orders/presentation/pages/checkout_page.dart';
import '../../core/widgets/splash_screen.dart';

/// Router configuration for the application
class AppRouter {
  /// Private constructor to prevent instantiation
  AppRouter._();

  /// Router key for navigation
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  /// Create and configure the GoRouter instance
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash',
      debugLogDiagnostics: true,

      // Redirect logic for authentication
      redirect: (BuildContext context, GoRouterState state) {
        final authState = authBloc.state;
        final isAuthenticated = authState is Authenticated;
        final isAuthRoute = state.matchedLocation.startsWith('/auth');
        final isSplashRoute = state.matchedLocation == '/splash';

        // Allow splash screen
        if (isSplashRoute) {
          return null;
        }

        // If not authenticated and trying to access protected route, redirect to login
        if (!isAuthenticated && !isAuthRoute) {
          return '/auth/login';
        }

        // If authenticated and trying to access auth routes, redirect to home
        if (isAuthenticated && isAuthRoute) {
          return '/';
        }

        // No redirect needed
        return null;
      },

      routes: [
        // Splash screen route
        GoRoute(
          path: '/splash',
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Home/Products route
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const ProductsPage(),
        ),

        // Authentication routes
        GoRoute(
          path: '/auth/login',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/auth/register',
          name: 'register',
          builder: (context, state) => const RegisterPage(),
        ),

        // Profile route
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),

        // Product routes
        GoRoute(
          path: '/products/:id',
          name: 'product-detail',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ProductDetailPage(productId: id);
          },
        ),
        GoRoute(
          path: '/search',
          name: 'search',
          builder: (context, state) => const SearchPage(),
        ),

        // Cart route
        GoRoute(
          path: '/cart',
          name: 'cart',
          builder: (context, state) => const CartPage(),
        ),

        // Wishlist route
        GoRoute(
          path: '/wishlist',
          name: 'wishlist',
          builder: (context, state) => const WishlistPage(),
        ),

        // Order routes
        GoRoute(
          path: '/orders',
          name: 'orders',
          builder: (context, state) => const OrdersPage(),
        ),
        GoRoute(
          path: '/orders/:id',
          name: 'order-detail',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return OrderDetailPage(orderId: id);
          },
        ),
        GoRoute(
          path: '/checkout',
          name: 'checkout',
          builder: (context, state) => const CheckoutPage(),
        ),
      ],

      // Error page
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Page not found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                state.error?.toString() ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
