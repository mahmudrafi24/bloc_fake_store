import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../domain/usecases/get_order_detail_usecase.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

/// BLoC for managing order state and operations
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetOrdersUseCase getOrdersUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final GetOrderDetailUseCase getOrderDetailUseCase;

  OrderBloc({
    required this.getOrdersUseCase,
    required this.createOrderUseCase,
    required this.getOrderDetailUseCase,
  }) : super(const OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CreateOrder>(_onCreateOrder);
    on<LoadOrderDetail>(_onLoadOrderDetail);
  }

  /// Handle LoadOrders event
  Future<void> _onLoadOrders(LoadOrders event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());

    final result = await getOrdersUseCase(NoParams());

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (orders) => emit(OrdersLoaded(orders: orders)),
    );
  }

  /// Handle CreateOrder event
  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await createOrderUseCase(
      CreateOrderParams(items: event.items, address: event.address),
    );

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderCreated(order: order)),
    );
  }

  /// Handle LoadOrderDetail event
  Future<void> _onLoadOrderDetail(
    LoadOrderDetail event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await getOrderDetailUseCase(
      GetOrderDetailParams(orderId: event.orderId),
    );

    result.fold(
      (failure) => emit(OrderError(message: failure.message)),
      (order) => emit(OrderDetailLoaded(order: order)),
    );
  }
}
