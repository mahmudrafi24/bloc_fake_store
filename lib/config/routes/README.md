# Navigation System

This directory contains the GoRouter configuration for the FakeStore app.

## Usage

### 1. Initialize the Router in main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes/app_router.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        loginUseCase: di.sl(),
        registerUseCase: di.sl(),
        logoutUseCase: di.sl(),
        getCurrentUserUseCase: di.sl(),
      )..add(const CheckAuthStatus()),
      child: Builder(
        builder: (context) {
          final authBloc = context.read<AuthBloc>();
          final router = AppRouter.createRouter(authBloc);

          return MaterialApp.router(
            title: 'FakeStore',
            routerConfig: router,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
          );
        },
      ),
    );
  }
}
```

### 2. Use Responsive Navigation

Wrap your pages with `ResponsiveNavigation` to automatically show:
- Bottom navigation bar on mobile
- Navigation rail on tablet
- Extended navigation rail on desktop

```dart
import 'package:flutter/material.dart';
import '../../../core/widgets/navigation/responsive_navigation.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavigation(
      child: Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: ProductGrid(),
      ),
    );
  }
}
```

### 3. Navigation Methods

Use GoRouter's context extensions for navigation:

```dart
// Navigate to a route
context.go('/products/123');

// Navigate with named route
context.goNamed('product-detail', pathParameters: {'id': '123'});

// Push a route (adds to stack)
context.push('/cart');

// Pop current route
context.pop();

// Replace current route
context.replace('/login');
```

## Available Routes

| Route | Name | Parameters | Description |
|-------|------|------------|-------------|
| `/` | home | - | Home/Products page |
| `/auth/login` | login | - | Login page |
| `/auth/register` | register | - | Registration page |
| `/profile` | profile | - | User profile page |
| `/products/:id` | product-detail | id (int) | Product detail page |
| `/search` | search | - | Product search page |
| `/cart` | cart | - | Shopping cart page |
| `/wishlist` | wishlist | - | Wishlist page |
| `/orders` | orders | - | Orders list page |
| `/orders/:id` | order-detail | id (int) | Order detail page |
| `/checkout` | checkout | - | Checkout page |

## Authentication Redirect

The router automatically handles authentication:
- Unauthenticated users accessing protected routes → redirected to `/auth/login`
- Authenticated users accessing auth routes → redirected to `/` (home)

## Cart Badge

The navigation widgets automatically display a badge on the cart icon showing the number of items in the cart. This is powered by the CartBloc and updates in real-time.

## Responsive Behavior

### Mobile (< 600px)
- Bottom navigation bar with 5 items: Home, Search, Cart, Wishlist, Profile
- Orders accessible via Profile page

### Tablet (600px - 1200px)
- Side navigation rail (collapsed)
- 6 items: Home, Search, Cart, Wishlist, Orders, Profile

### Desktop (> 1200px)
- Extended side navigation rail with labels
- 6 items: Home, Search, Cart, Wishlist, Orders, Profile
- App logo and name displayed at the top
