import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// Parameters for getting order details
class GetOrderDetailParams extends Equatable {
  final int orderId;

  const GetOrderDetailParams({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

/// Use case for retrieving a specific order by ID
class GetOrderDetailUseCase extends UseCase<Order, GetOrderDetailParams> {
  final OrderRepository repository;

  GetOrderDetailUseCase(this.repository);

  @override
  Future<Either<Failure, Order>> call(GetOrderDetailParams params) async {
    return await repository.getOrderById(params.orderId);
  }
}
