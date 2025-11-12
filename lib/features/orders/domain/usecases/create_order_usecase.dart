import 'package:dartz/dartz.dart' hide Order;
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../authentication/domain/entities/user.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// Parameters for creating an order
class CreateOrderParams extends Equatable {
  final List<CartItem> items;
  final Address address;

  const CreateOrderParams({required this.items, required this.address});

  @override
  List<Object?> get props => [items, address];
}

/// Use case for creating a new order
class CreateOrderUseCase extends UseCase<Order, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, Order>> call(CreateOrderParams params) async {
    return await repository.createOrder(params.items, params.address);
  }
}
