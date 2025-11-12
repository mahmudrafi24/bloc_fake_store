import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

/// BLoC for managing cart state and operations
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartBloc({
    required this.getCartItemsUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.removeFromCartUseCase,
    required this.clearCartUseCase,
  }) : super(const CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<RemoveItem>(_onRemoveItem);
    on<ClearCart>(_onClearCart);
  }

  /// Handle LoadCart event
  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());

    final result = await getCartItemsUseCase(NoParams());

    result.fold((failure) => emit(CartError(message: failure.message)), (
      items,
    ) {
      final itemCount = items.fold<int>(0, (sum, item) => sum + item.quantity);
      final totalPrice = items.fold<double>(
        0,
        (sum, item) => sum + item.subtotal,
      );

      emit(
        CartLoaded(items: items, itemCount: itemCount, totalPrice: totalPrice),
      );
    });
  }

  /// Handle AddToCart event
  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final result = await addToCartUseCase(
      AddToCartParams(product: event.product, quantity: event.quantity),
    );

    result.fold((failure) => emit(CartError(message: failure.message)), (_) {
      // Reload cart after adding item
      add(const LoadCart());
    });
  }

  /// Handle UpdateQuantity event
  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    final result = await updateCartItemUseCase(
      UpdateCartItemParams(
        productId: event.productId,
        quantity: event.quantity,
      ),
    );

    result.fold((failure) => emit(CartError(message: failure.message)), (_) {
      // Reload cart after updating quantity
      add(const LoadCart());
    });
  }

  /// Handle RemoveItem event
  Future<void> _onRemoveItem(RemoveItem event, Emitter<CartState> emit) async {
    final result = await removeFromCartUseCase(
      RemoveFromCartParams(productId: event.productId),
    );

    result.fold((failure) => emit(CartError(message: failure.message)), (_) {
      // Reload cart after removing item
      add(const LoadCart());
    });
  }

  /// Handle ClearCart event
  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final result = await clearCartUseCase(NoParams());

    result.fold((failure) => emit(CartError(message: failure.message)), (_) {
      // Reload cart after clearing
      add(const LoadCart());
    });
  }
}
