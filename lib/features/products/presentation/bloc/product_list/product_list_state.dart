import 'package:equatable/equatable.dart';
import 'package:fake_store/features/products/domain/entities/product.dart';

/// Base class for ProductList states
abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any products are loaded
class ProductListInitial extends ProductListState {
  const ProductListInitial();
}

/// State when products are being loaded
class ProductListLoading extends ProductListState {
  const ProductListLoading();
}

/// State when products are successfully loaded
class ProductListLoaded extends ProductListState {
  final List<Product> products;
  final List<String> categories;
  final String? selectedCategory;
  final String? searchQuery;

  const ProductListLoaded({
    required this.products,
    required this.categories,
    this.selectedCategory,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [
    products,
    categories,
    selectedCategory,
    searchQuery,
  ];

  /// Create a copy of this state with updated fields
  ProductListLoaded copyWith({
    List<Product>? products,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    bool clearCategory = false,
    bool clearSearch = false,
  }) {
    return ProductListLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: clearCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
    );
  }
}

/// State when there's an error loading products
class ProductListError extends ProductListState {
  final String message;

  const ProductListError(this.message);

  @override
  List<Object?> get props => [message];
}
