import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store/core/usecases/usecase.dart';
import 'package:fake_store/features/products/domain/usecases/get_products_usecase.dart';
import 'package:fake_store/features/products/domain/usecases/search_products_usecase.dart';
import 'package:fake_store/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:fake_store/features/products/domain/usecases/get_products_by_category_usecase.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

/// BLoC for managing product list state
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase getProductsUseCase;
  final SearchProductsUseCase searchProductsUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;

  ProductListBloc({
    required this.getProductsUseCase,
    required this.searchProductsUseCase,
    required this.getCategoriesUseCase,
    required this.getProductsByCategoryUseCase,
  }) : super(const ProductListInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
    on<RefreshProducts>(_onRefreshProducts);
  }

  /// Handle LoadProducts event
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductListState> emit,
  ) async {
    emit(const ProductListLoading());

    // Fetch products and categories in parallel
    final productsResult = await getProductsUseCase(NoParams());
    final categoriesResult = await getCategoriesUseCase(NoParams());

    productsResult.fold((failure) => emit(ProductListError(failure.message)), (
      products,
    ) {
      categoriesResult.fold(
        (failure) =>
            emit(ProductListLoaded(products: products, categories: [])),
        (categories) =>
            emit(ProductListLoaded(products: products, categories: categories)),
      );
    });
  }

  /// Handle SearchProducts event
  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductListState> emit,
  ) async {
    if (event.query.isEmpty) {
      // If search query is empty, reload all products
      add(const LoadProducts());
      return;
    }

    emit(const ProductListLoading());

    final result = await searchProductsUseCase(
      SearchParams(query: event.query),
    );

    result.fold((failure) => emit(ProductListError(failure.message)), (
      products,
    ) {
      // Preserve categories if we have them from previous state
      final categories = state is ProductListLoaded
          ? (state as ProductListLoaded).categories
          : <String>[];

      emit(
        ProductListLoaded(
          products: products,
          categories: categories,
          searchQuery: event.query,
        ),
      );
    });
  }

  /// Handle FilterByCategory event
  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProductListState> emit,
  ) async {
    if (event.category == null) {
      // If category is null, reload all products
      add(const LoadProducts());
      return;
    }

    emit(const ProductListLoading());

    final result = await getProductsByCategoryUseCase(
      CategoryParams(category: event.category!),
    );

    result.fold((failure) => emit(ProductListError(failure.message)), (
      products,
    ) {
      // Preserve categories if we have them from previous state
      final categories = state is ProductListLoaded
          ? (state as ProductListLoaded).categories
          : <String>[];

      emit(
        ProductListLoaded(
          products: products,
          categories: categories,
          selectedCategory: event.category,
        ),
      );
    });
  }

  /// Handle RefreshProducts event
  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductListState> emit,
  ) async {
    // Preserve current filter state
    final currentState = state;

    if (currentState is ProductListLoaded) {
      // If we have a search query, refresh search results
      if (currentState.searchQuery != null &&
          currentState.searchQuery!.isNotEmpty) {
        add(SearchProducts(currentState.searchQuery!));
        return;
      }

      // If we have a selected category, refresh category filter
      if (currentState.selectedCategory != null) {
        add(FilterByCategory(currentState.selectedCategory));
        return;
      }
    }

    // Otherwise, just reload all products
    add(const LoadProducts());
  }
}
