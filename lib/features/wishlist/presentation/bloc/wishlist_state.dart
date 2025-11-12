import 'package:equatable/equatable.dart';
import '../../domain/entities/wishlist_item.dart';

/// Base class for all wishlist states
abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any wishlist operations
class WishlistInitial extends WishlistState {
  const WishlistInitial();
}

/// State when wishlist operations are in progress
class WishlistLoading extends WishlistState {
  const WishlistLoading();
}

/// State when wishlist items are successfully loaded
class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;
  final Map<int, bool> wishlistStatus;

  const WishlistLoaded({required this.items, this.wishlistStatus = const {}});

  @override
  List<Object?> get props => [items, wishlistStatus];

  /// Create a copy of this state with updated values
  WishlistLoaded copyWith({
    List<WishlistItem>? items,
    Map<int, bool>? wishlistStatus,
  }) {
    return WishlistLoaded(
      items: items ?? this.items,
      wishlistStatus: wishlistStatus ?? this.wishlistStatus,
    );
  }
}

/// State when a wishlist operation fails
class WishlistError extends WishlistState {
  final String message;

  const WishlistError({required this.message});

  @override
  List<Object?> get props => [message];
}
