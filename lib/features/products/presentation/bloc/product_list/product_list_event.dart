import 'package:equatable/equatable.dart';

/// Base class for ProductList events
abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all products
class LoadProducts extends ProductListEvent {
  const LoadProducts();
}

/// Event to search products by query
class SearchProducts extends ProductListEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to filter products by category
class FilterByCategory extends ProductListEvent {
  final String? category; // null means show all products

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

/// Event to refresh products
class RefreshProducts extends ProductListEvent {
  const RefreshProducts();
}
