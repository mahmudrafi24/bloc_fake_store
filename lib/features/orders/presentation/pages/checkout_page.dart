import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../injection_container.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/checkout_form.dart';

/// Page for checkout process with cart summary and address form
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CartBloc>()..add(const LoadCart()),
        ),
        BlocProvider(create: (context) => sl<OrderBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, orderState) {
            if (orderState is OrderCreated) {
              // Clear cart after successful order
              context.read<CartBloc>().add(const ClearCart());

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                  backgroundColor: Colors.green,
                ),
              );

              // Navigate to orders page
              context.go('/orders');
            } else if (orderState is OrderError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(orderState.message),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'Retry',
                    textColor: Colors.white,
                    onPressed: () {
                      // User can retry by submitting the form again
                    },
                  ),
                ),
              );
            }
          },
          builder: (context, orderState) {
            return BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                if (cartState is CartLoading) {
                  return const AppLoadingWidget();
                }

                if (cartState is CartLoaded) {
                  if (cartState.items.isEmpty) {
                    return _buildEmptyCartState(context);
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Cart Summary Section
                        _buildCartSummary(context, cartState),
                        const SizedBox(height: 24),

                        // Checkout Form Section
                        CheckoutForm(
                          onAddressSubmitted: (address) {
                            // Create order with cart items and address
                            context.read<OrderBloc>().add(
                              CreateOrder(
                                items: cartState.items,
                                address: address,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Place Order Button
                        ElevatedButton(
                          onPressed: orderState is OrderLoading
                              ? null
                              : () {
                                  // Trigger form submission
                                  final formState = context
                                      .findAncestorStateOfType<FormState>();
                                  if (formState?.validate() ?? false) {
                                    // Form will call onAddressSubmitted
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: orderState is OrderLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Place Order (\$${cartState.totalPrice.toStringAsFixed(2)})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  );
                }

                if (cartState is CartError) {
                  return _buildErrorState(context, cartState.message);
                }

                return const AppLoadingWidget();
              },
            );
          },
        ),
      ),
    );
  }

  /// Build cart summary widget
  Widget _buildCartSummary(BuildContext context, CartLoaded cartState) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...cartState.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product.title} x${item.quantity}',
                        style: const TextStyle(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${item.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (${cartState.itemCount} items)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${cartState.totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build empty cart state widget
  Widget _buildEmptyCartState(BuildContext context) {
    return EmptyStateWidget(
      title: 'Your cart is empty',
      message: 'Add items before checkout',
      icon: Icons.shopping_cart_outlined,
      actionLabel: 'Continue Shopping',
      onAction: () {
        context.go('/');
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
