import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../injection_container.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/cart_summary.dart';

/// Page to display shopping cart with items and checkout option
class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CartBloc>()..add(const LoadCart()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shopping Cart'),
          actions: [
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                if (state is CartLoaded && state.items.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: 'Clear Cart',
                    onPressed: () {
                      // Show confirmation dialog
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Clear Cart'),
                          content: const Text(
                            'Are you sure you want to remove all items from your cart?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                                context.read<CartBloc>().add(const ClearCart());
                              },
                              child: const Text(
                                'Clear',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'Retry',
                    textColor: Colors.white,
                    onPressed: () {
                      context.read<CartBloc>().add(const LoadCart());
                    },
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CartLoading) {
              return const AppLoadingWidget();
            }

            if (state is CartLoaded) {
              if (state.items.isEmpty) {
                return _buildEmptyState(context);
              }

              return Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return CartItemWidget(item: state.items[index]);
                      },
                    ),
                  ),

                  // Cart Summary
                  CartSummary(
                    itemCount: state.itemCount,
                    totalPrice: state.totalPrice,
                    onCheckout: () {
                      // Navigate to checkout page
                      // TODO: Implement navigation when checkout page is ready
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Checkout feature coming soon!'),
                        ),
                      );
                    },
                  ),
                ],
              );
            }

            if (state is CartError) {
              return _buildErrorState(context, state.message);
            }

            // Initial state
            return _buildEmptyState(context);
          },
        ),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Your cart is empty',
      message: 'Add items to get started',
      icon: Icons.shopping_cart_outlined,
      actionLabel: 'Continue Shopping',
      onAction: () {
        Navigator.of(context).pop();
      },
    );
  }

  /// Build error state widget
  Widget _buildErrorState(BuildContext context, String message) {
    return AppErrorWidget(
      message: message,
      onRetry: () {
        context.read<CartBloc>().add(const LoadCart());
      },
    );
  }
}
