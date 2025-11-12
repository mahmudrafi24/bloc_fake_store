import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_to_wishlist_usecase.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/remove_from_wishlist_usecase.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

/// BLoC for managing wishlist state and operations
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlistUseCase getWishlistUseCase;
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;

  WishlistBloc({
    required this.getWishlistUseCase,
    required this.addToWishlistUseCase,
    required this.removeFromWishlistUseCase,
  }) : super(const WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddToWishlist>(_onAddToWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
    on<CheckWishlistStatus>(_onCheckWishlistStatus);
  }

  /// Handle LoadWishlist event
  Future<void> _onLoadWishlist(
    LoadWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    emit(const WishlistLoading());

    final result = await getWishlistUseCase(NoParams());

    result.fold((failure) => emit(WishlistError(message: failure.message)), (
      items,
    ) {
      // Create a map of product IDs to wishlist status
      final wishlistStatus = <int, bool>{};
      for (final item in items) {
        wishlistStatus[item.product.id] = true;
      }

      emit(WishlistLoaded(items: items, wishlistStatus: wishlistStatus));
    });
  }

  /// Handle AddToWishlist event
  Future<void> _onAddToWishlist(
    AddToWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    final result = await addToWishlistUseCase(
      AddToWishlistParams(product: event.product),
    );

    result.fold((failure) => emit(WishlistError(message: failure.message)), (
      _,
    ) {
      // Reload wishlist after adding item
      add(const LoadWishlist());
    });
  }

  /// Handle RemoveFromWishlist event
  Future<void> _onRemoveFromWishlist(
    RemoveFromWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    final result = await removeFromWishlistUseCase(
      RemoveFromWishlistParams(productId: event.productId),
    );

    result.fold((failure) => emit(WishlistError(message: failure.message)), (
      _,
    ) {
      // Reload wishlist after removing item
      add(const LoadWishlist());
    });
  }

  /// Handle CheckWishlistStatus event
  Future<void> _onCheckWishlistStatus(
    CheckWishlistStatus event,
    Emitter<WishlistState> emit,
  ) async {
    // This event is used to check if a product is in the wishlist
    // The status is maintained in the WishlistLoaded state
    // No additional action needed here as the status is already tracked
  }
}
