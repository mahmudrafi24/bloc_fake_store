import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../injection_container.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';
import '../widgets/order_card.dart';

/// Page to display list of user orders
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderBloc>()..add(const LoadOrders()),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: BlocConsumer<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  action: SnackBarAction(
                    label: 'Retry',
                    textColor: Colors.white,
                    onPressed: () {
                      context.read<OrderBloc>().add(const LoadOrders());
                    },
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrderLoading) {
              return const AppLoadingWidget();
            }

            if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<OrderBloc>().add(const LoadOrders());
                  // Wait for the state to update
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.orders.length,
                  itemBuilder: (context, index) {
                    return OrderCard(order: state.orders[index]);
                  },
                ),
              );
            }

            if (state is OrderError) {
              return _buildErrorState(context, state.message);
            }

            // Initial state
            return const AppLoadingWidget();
          },
        ),
      ),
    );
  }

  /// Build empty state widget
  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      title: 'No orders yet',
      message: 'Start shopping to create your first order',
      icon: Icons.receipt_long_outlined,
      actionLabel: 'Start Shopping',
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
        context.read<OrderBloc>().add(const LoadOrders());
      },
    );
  }
}
