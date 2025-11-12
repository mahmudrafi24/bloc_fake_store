import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// Use case for retrieving all orders for the current user
class GetOrdersUseCase extends UseCase<List<Order>, NoParams> {
  final OrderRepository repository;

  GetOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<Order>>> call(NoParams params) async {
    return await repository.getOrders();
  }
}
