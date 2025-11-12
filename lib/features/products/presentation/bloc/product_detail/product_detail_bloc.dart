import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fake_store/features/products/domain/usecases/get_product_detail_usecase.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

/// BLoC for managing product detail state
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductDetailUseCase getProductDetailUseCase;

  ProductDetailBloc({required this.getProductDetailUseCase})
    : super(const ProductDetailInitial()) {
    on<LoadProductDetail>(_onLoadProductDetail);
  }

  /// Handle LoadProductDetail event
  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailLoading());

    final result = await getProductDetailUseCase(
      ProductDetailParams(productId: event.productId),
    );

    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }
}
