import 'package:flutter/material.dart';
import '../../utils/responsive.dart';
import 'bottom_nav_bar.dart';
import 'nav_rail.dart';

/// Responsive navigation wrapper that switches between bottom nav and nav rail
class ResponsiveNavigation extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Child widget to display in the main content area
  final Widget child;

  const ResponsiveNavigation({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  /// Build mobile layout with bottom navigation bar
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavBar(currentIndex: currentIndex),
    );
  }

  /// Build tablet layout with navigation rail
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppNavRail(currentIndex: currentIndex),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  /// Build desktop layout with extended navigation rail
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AppNavRail(currentIndex: currentIndex, extended: true),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
