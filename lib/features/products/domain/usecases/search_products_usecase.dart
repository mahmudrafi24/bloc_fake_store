import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_store/core/errors/failures.dart';
import 'package:fake_store/core/usecases/usecase.dart';
import 'package:fake_store/features/products/domain/entities/product.dart';
import 'package:fake_store/features/products/domain/repositories/product_repository.dart';

/// Use case for searching products by query
class SearchProductsUseCase extends UseCase<List<Product>, SearchParams> {
  final ProductRepository repository;

  SearchProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(SearchParams params) async {
    return await repository.searchProducts(params.query);
  }
}

/// Parameters for SearchProductsUseCase
class SearchParams extends Equatable {
  final String query;

  const SearchParams({required this.query});

  @override
  List<Object> get props => [query];
}
