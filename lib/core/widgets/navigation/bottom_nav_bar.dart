import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../../features/cart/presentation/bloc/cart_state.dart';

/// Bottom navigation bar for mobile devices
class AppBottomNavBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onItemTapped(context, index),
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: _buildCartIcon(context),
          activeIcon: _buildCartIcon(context, isActive: true),
          label: 'Cart',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
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

  /// Handle navigation item tap
  void _onItemTapped(BuildContext context, int index) {
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
        context.go('/profile');
        break;
    }
  }
}
