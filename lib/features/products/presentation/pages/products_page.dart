import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store/core/constants/app_colors.dart';
import 'package:fake_store/core/constants/app_strings.dart';
import 'package:fake_store/core/widgets/error_widget.dart';
import 'package:fake_store/core/widgets/loading_widget.dart';
import 'package:fake_store/core/widgets/empty_state_widget.dart';
import 'package:fake_store/features/products/domain/entities/product.dart';
import 'package:fake_store/features/products/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:fake_store/features/products/presentation/bloc/product_list/product_list_event.dart';
import 'package:fake_store/features/products/presentation/bloc/product_list/product_list_state.dart';
import 'package:fake_store/features/products/presentation/widgets/category_filter.dart';
import 'package:fake_store/features/products/presentation/widgets/product_grid.dart';
import 'package:fake_store/features/products/presentation/pages/search_page.dart';
import 'package:fake_store/injection_container.dart';

/// Main products page displaying product grid with filters
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductListBloc>()..add(const LoadProducts()),
      child: const _ProductsPageContent(),
    );
  }
}

class _ProductsPageContent extends StatelessWidget {
  const _ProductsPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.products),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchPage()),
              );
            },
            tooltip: AppStrings.search,
          ),
        ],
      ),
      body: BlocConsumer<ProductListBloc, ProductListState>(
        listener: (context, state) {
          // Show error messages via SnackBar
          if (state is ProductListError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                action: SnackBarAction(
                  label: AppStrings.retry,
                  textColor: AppColors.textWhite,
                  onPressed: () {
                    context.read<ProductListBloc>().add(const LoadProducts());
                  },
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Category filter
              if (state is ProductListLoaded && state.categories.isNotEmpty)
                CategoryFilter(
                  categories: state.categories,
                  selectedCategory: state.selectedCategory,
                ),

              // Product grid or loading/error states
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  /// Build the main body based on current state
  Widget _buildBody(BuildContext context, ProductListState state) {
    if (state is ProductListLoading) {
      return _buildLoadingState();
    } else if (state is ProductListLoaded) {
      if (state.products.isEmpty) {
        return _buildEmptyState(context);
      }
      return _buildProductGrid(context, state);
    } else if (state is ProductListError) {
      return _buildErrorState(context, state.message);
    }

    // Initial state
    return const SizedBox.shrink();
  }

  /// Build loading indicator
  Widget _buildLoadingState() {
    return const AppLoadingWidget(message: AppStrings.loading);
  }

  /// Build empty state when no products found
  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: AppStrings.noProductsFound,
      message: 'Try adjusting your filters',
      icon: Icons.shopping_bag_outlined,
      actionLabel: AppStrings.retry,
      onAction: () {
        context.read<ProductListBloc>().add(const LoadProducts());
      },
    );
  }

  /// Build error state with retry button
  Widget _buildErrorState(BuildContext context, String message) {
    return AppErrorWidget(
      message: message,
      onRetry: () {
        context.read<ProductListBloc>().add(const LoadProducts());
      },
    );
  }

  /// Build product grid with pull-to-refresh
  Widget _buildProductGrid(BuildContext context, ProductListLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductListBloc>().add(const RefreshProducts());
        // Wait for the refresh to complete
        await context.read<ProductListBloc>().stream.firstWhere(
          (state) => state is! ProductListLoading,
        );
      },
      color: AppColors.primary,
      child: ProductGrid(
        products: state.products,
        onProductTap: (product) {
          // TODO: Navigate to product detail page when routing is implemented
          _showProductDetailPlaceholder(context, product);
        },
        onWishlistTap: (product) {
          // TODO: Integrate with WishlistBloc when implemented
          _showWishlistPlaceholder(context, product);
        },
        isInWishlist: (product) {
          // TODO: Check wishlist status when WishlistBloc is implemented
          return false;
        },
      ),
    );
  }

  /// Show placeholder for product detail navigation
  void _showProductDetailPlaceholder(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Product detail page for "${product.title}" will be implemented',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show placeholder for wishlist functionality
  void _showWishlistPlaceholder(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Wishlist functionality will be implemented'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
