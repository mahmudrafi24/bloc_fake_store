import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_store/core/errors/failures.dart';
import 'package:fake_store/core/usecases/usecase.dart';
import 'package:fake_store/features/products/domain/entities/product.dart';
import 'package:fake_store/features/products/domain/repositories/product_repository.dart';

/// Use case for fetching products filtered by category
class GetProductsByCategoryUseCase
    extends UseCase<List<Product>, CategoryParams> {
  final ProductRepository repository;

  GetProductsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(CategoryParams params) async {
    return await repository.getProductsByCategory(params.category);
  }
}

/// Parameters for GetProductsByCategoryUseCase
class CategoryParams extends Equatable {
  final String category;

  const CategoryParams({required this.category});

  @override
  List<Object> get props => [category];
}
