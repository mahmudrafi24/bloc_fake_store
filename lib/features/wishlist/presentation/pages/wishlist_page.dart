import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../injection_container.dart';
import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';
import '../widgets/wishlist_item_widget.dart';

/// Page displaying user's wishlist items
class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WishlistBloc>()..add(const LoadWishlist()),
      child: const _WishlistPageContent(),
    );
  }
}

class _WishlistPageContent extends StatelessWidget {
  const _WishlistPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.wishlist),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
      ),
      body: BlocConsumer<WishlistBloc, WishlistState>(
        listener: (context, state) {
          // Show error messages via SnackBar
          if (state is WishlistError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                action: SnackBarAction(
                  label: AppStrings.retry,
                  textColor: AppColors.textWhite,
                  onPressed: () {
                    context.read<WishlistBloc>().add(const LoadWishlist());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return _buildBody(context, state);
        },
      ),
    );
  }

  /// Build the main body based on current state
  Widget _buildBody(BuildContext context, WishlistState state) {
    if (state is WishlistLoading) {
      return _buildLoadingState();
    } else if (state is WishlistLoaded) {
      if (state.items.isEmpty) {
        return _buildEmptyState(context);
      }
      return _buildWishlistGrid(context, state);
    } else if (state is WishlistError) {
      return _buildErrorState(context, state.message);
    }

    // Initial state
    return const SizedBox.shrink();
  }

  /// Build loading indicator
  Widget _buildLoadingState() {
    return const AppLoadingWidget(message: AppStrings.loading);
  }

  /// Build empty state when wishlist is empty
  Widget _buildEmptyState(BuildContext context) {
    return const EmptyStateWidget(
      title: 'Your wishlist is empty',
      message: 'Add products you love to your wishlist',
      icon: Icons.favorite_border,
    );
  }

  /// Build error state with retry button
  Widget _buildErrorState(BuildContext context, String message) {
    return AppErrorWidget(
      message: message,
      onRetry: () {
        context.read<WishlistBloc>().add(const LoadWishlist());
      },
    );
  }

  /// Build wishlist grid with responsive layout
  Widget _buildWishlistGrid(BuildContext context, WishlistLoaded state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);
        final childAspectRatio = _getChildAspectRatio(constraints.maxWidth);

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            final item = state.items[index];
            return WishlistItemWidget(item: item);
          },
        );
      },
    );
  }

  /// Determine number of columns based on screen width
  int _getCrossAxisCount(double width) {
    if (width >= 1200) {
      // Desktop: 4 columns
      return 4;
    } else if (width >= 600) {
      // Tablet: 3 columns
      return 3;
    } else {
      // Mobile: 2 columns
      return 2;
    }
  }

  /// Calculate child aspect ratio based on screen size
  double _getChildAspectRatio(double width) {
    if (width >= 1200) {
      return 0.7; // Desktop
    } else if (width >= 600) {
      return 0.75; // Tablet
    } else {
      return 0.68; // Mobile
    }
  }
}
