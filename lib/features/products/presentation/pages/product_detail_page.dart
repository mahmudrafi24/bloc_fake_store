import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fake_store/core/constants/app_colors.dart';
import 'package:fake_store/core/constants/app_strings.dart';
import 'package:fake_store/core/constants/app_text_styles.dart';
import 'package:fake_store/core/utils/formatters.dart';
import 'package:fake_store/core/widgets/error_widget.dart';
import 'package:fake_store/core/widgets/loading_widget.dart';
import 'package:fake_store/features/products/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:fake_store/features/products/presentation/bloc/product_detail/product_detail_event.dart';
import 'package:fake_store/features/products/presentation/bloc/product_detail/product_detail_state.dart';
import 'package:fake_store/injection_container.dart';

/// Page displaying detailed product information
class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ProductDetailBloc>()..add(LoadProductDetail(productId)),
      child: _ProductDetailPageContent(productId: productId),
    );
  }
}

class _ProductDetailPageContent extends StatefulWidget {
  final int productId;

  const _ProductDetailPageContent({required this.productId});

  @override
  State<_ProductDetailPageContent> createState() =>
      _ProductDetailPageContentState();
}

class _ProductDetailPageContentState extends State<_ProductDetailPageContent> {
  bool _isInWishlist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProductDetailBloc, ProductDetailState>(
        listener: (context, state) {
          // Show error message if loading fails
          if (state is ProductDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductDetailLoading) {
            return const Scaffold(
              body: AppLoadingWidget(message: AppStrings.loading),
            );
          }

          if (state is ProductDetailError) {
            return Scaffold(
              appBar: AppBar(),
              body: AppErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<ProductDetailBloc>().add(
                    LoadProductDetail(widget.productId),
                  );
                },
              ),
            );
          }

          if (state is ProductDetailLoaded) {
            final product = state.product;

            return CustomScrollView(
              slivers: [
                // App Bar with product image
                SliverAppBar(
                  expandedHeight: 400,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: AppColors.background,
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    // Wishlist button
                    IconButton(
                      icon: Icon(
                        _isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: _isInWishlist ? AppColors.error : null,
                      ),
                      onPressed: () {
                        setState(() {
                          _isInWishlist = !_isInWishlist;
                        });
                        // TODO: Integrate with WishlistBloc when implemented
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isInWishlist
                                  ? AppStrings.successAddToWishlist
                                  : AppStrings.successRemoveFromWishlist,
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                // Product details
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category chip
                        Chip(
                          label: Text(
                            product.category.toUpperCase(),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        const SizedBox(height: 12),
                        // Product title
                        Text(product.title, style: AppTextStyles.h4),
                        const SizedBox(height: 12),
                        // Rating
                        if (product.rating != null)
                          Row(
                            children: [
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < product.rating!.rate.floor()
                                      ? Icons.star
                                      : index < product.rating!.rate
                                      ? Icons.star_half
                                      : Icons.star_border,
                                  color: AppColors.rating,
                                  size: 20,
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                Formatters.formatRating(product.rating!.rate),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${product.rating!.count} reviews)',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        // Price
                        Text(
                          Formatters.formatPrice(product.price),
                          style: AppTextStyles.price,
                        ),
                        const SizedBox(height: 24),
                        // Description heading
                        Text(AppStrings.description, style: AppTextStyles.h6),
                        const SizedBox(height: 8),
                        // Description
                        Text(
                          product.description,
                          style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                        ),
                        const SizedBox(height: 100), // Space for bottom button
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Initial state
          return const Scaffold(body: AppLoadingWidget());
        },
      ),
      // Add to Cart button
      bottomSheet: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          if (state is ProductDetailLoaded) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Integrate with CartBloc when implemented
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(AppStrings.successAddToCart),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text(AppStrings.addToCart),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
