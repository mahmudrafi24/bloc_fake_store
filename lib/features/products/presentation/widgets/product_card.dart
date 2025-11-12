import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fake_store/core/constants/app_colors.dart';
import 'package:fake_store/core/constants/app_text_styles.dart';
import 'package:fake_store/core/utils/formatters.dart';
import 'package:fake_store/features/products/domain/entities/product.dart';

/// Reusable product card widget
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onWishlistTap;
  final bool isInWishlist;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onWishlistTap,
    this.isInWishlist = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Wishlist Button
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Product Image
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.error_outline,
                            color: AppColors.error,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Wishlist Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Material(
                      color: AppColors.surface,
                      shape: const CircleBorder(),
                      elevation: 2,
                      child: InkWell(
                        onTap: onWishlistTap,
                        customBorder: const CircleBorder(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist
                                ? AppColors.error
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Product Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Expanded(
                      child: Text(
                        product.title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rating
                    if (product.rating != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.rating,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            Formatters.formatRating(product.rating!.rate),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${product.rating!.count})',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    // Price
                    Text(
                      Formatters.formatPrice(product.price),
                      style: AppTextStyles.priceSmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
