import 'package:flutter/material.dart';
import 'package:fake_store/features/products/domain/entities/product.dart';
import 'package:fake_store/features/products/presentation/widgets/product_card.dart';

/// Responsive grid widget for displaying products
class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;
  final Function(Product) onWishlistTap;
  final bool Function(Product) isInWishlist;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onWishlistTap,
    required this.isInWishlist,
  });

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

  @override
  Widget build(BuildContext context) {
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
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              onTap: () => onProductTap(product),
              onWishlistTap: () => onWishlistTap(product),
              isInWishlist: isInWishlist(product),
            );
          },
        );
      },
    );
  }
}
