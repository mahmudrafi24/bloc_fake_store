import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../../features/cart/presentation/bloc/cart_state.dart';

/// Navigation rail for tablet and desktop devices
class AppNavRail extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Whether to show extended labels
  final bool extended;

  const AppNavRail({
    super.key,
    required this.currentIndex,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: currentIndex,
      extended: extended,
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.all,
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Home'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.search_outlined),
          selectedIcon: Icon(Icons.search),
          label: Text('Search'),
        ),
        NavigationRailDestination(
          icon: _buildCartIcon(context),
          selectedIcon: _buildCartIcon(context, isActive: true),
          label: const Text('Cart'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.favorite_outline),
          selectedIcon: Icon(Icons.favorite),
          label: Text('Wishlist'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: Text('Orders'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }

  /// Build cart icon with badge showing item count
  Widget _buildCartIcon(BuildContext context, {bool isActive = false}) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final itemCount = state is CartLoaded ? state.itemCount : 0;

        return Badge(
          label: Text(itemCount.toString()),
          isLabelVisible: itemCount > 0,
          child: Icon(
            isActive ? Icons.shopping_cart : Icons.shopping_cart_outlined,
          ),
        );
      },
    );
  }

  /// Handle navigation destination selection
  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/wishlist');
        break;
      case 4:
        context.go('/orders');
        break;
      case 5:
        context.go('/profile');
        break;
    }
  }
}
