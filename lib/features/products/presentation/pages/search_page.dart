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
import 'package:fake_store/features/products/presentation/widgets/product_grid.dart';
import 'package:fake_store/injection_container.dart';

/// Search page for searching products
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch(BuildContext context, String query) {
    if (query.trim().isNotEmpty) {
      context.read<ProductListBloc>().add(SearchProducts(query.trim()));
    }
  }

  void _clearSearch(BuildContext context) {
    _searchController.clear();
    context.read<ProductListBloc>().add(const LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductListBloc>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
          title: _buildSearchBar(context),
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
                      final query = _searchController.text.trim();
                      if (query.isNotEmpty) {
                        _performSearch(context, query);
                      }
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
      ),
    );
  }

  /// Build search bar in app bar
  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      style: const TextStyle(color: AppColors.textWhite),
      decoration: InputDecoration(
        hintText: AppStrings.searchProducts,
        hintStyle: TextStyle(color: AppColors.textWhite.withValues(alpha: 0.7)),
        border: InputBorder.none,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.textWhite),
                onPressed: () {
                  _clearSearch(context);
                  setState(() {});
                },
              )
            : null,
      ),
      textInputAction: TextInputAction.search,
      onChanged: (value) {
        setState(() {}); // Rebuild to show/hide clear button
      },
      onSubmitted: (query) {
        _performSearch(context, query);
      },
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
      return _buildSearchResults(context, state);
    } else if (state is ProductListError) {
      return _buildErrorState(context, state.message);
    }

    // Initial state - show search prompt
    return _buildSearchPrompt();
  }

  /// Build loading indicator
  Widget _buildLoadingState() {
    return const AppLoadingWidget(message: AppStrings.loading);
  }

  /// Build empty state when no products found
  Widget _buildEmptyState(BuildContext context) {
    return const EmptyStateWidget(
      title: AppStrings.noProductsFound,
      message: 'Try searching with different keywords',
      icon: Icons.search_off,
    );
  }

  /// Build error state with retry button
  Widget _buildErrorState(BuildContext context, String message) {
    return AppErrorWidget(
      message: message,
      onRetry: () {
        final query = _searchController.text.trim();
        if (query.isNotEmpty) {
          _performSearch(context, query);
        }
      },
    );
  }

  /// Build search prompt for initial state
  Widget _buildSearchPrompt() {
    return const EmptyStateWidget(
      title: 'Search for products',
      message: 'Enter keywords to find products',
      icon: Icons.search,
    );
  }

  /// Build search results with product grid
  Widget _buildSearchResults(BuildContext context, ProductListLoaded state) {
    return Column(
      children: [
        // Search results header
        if (state.searchQuery != null && state.searchQuery!.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: AppColors.background,
            child: Text(
              'Found ${state.products.length} result${state.products.length != 1 ? 's' : ''} for "${state.searchQuery}"',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
          ),

        // Product grid
        Expanded(
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
        ),
      ],
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
      const SnackBar(
        content: Text('Wishlist functionality will be implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
