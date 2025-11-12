import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_store/core/errors/failures.dart';
import 'package:fake_store/core/usecases/usecase.dart';
import 'package:fake_store/features/products/domain/entities/product.dart';
import 'package:fake_store/features/products/domain/repositories/product_repository.dart';

/// Use case for fetching a single product by ID
class GetProductDetailUseCase extends UseCase<Product, ProductDetailParams> {
  final ProductRepository repository;

  GetProductDetailUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(ProductDetailParams params) async {
    return await repository.getProductById(params.productId);
  }
}

/// Parameters for GetProductDetailUseCase
class ProductDetailParams extends Equatable {
  final int productId;

  const ProductDetailParams({required this.productId});

  @override
  List<Object> get props => [productId];
}
