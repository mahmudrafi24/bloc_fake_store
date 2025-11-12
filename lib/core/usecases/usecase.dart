import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Base class for all use cases in the application
///
/// [Type] is the return type of the use case
/// [Params] is the input parameter type for the use case
abstract class UseCase<Type, Params> {
  /// Executes the use case
  ///
  /// Returns [Either<Failure, Type>] where:
  /// - Left side contains a [Failure] if the operation fails
  /// - Right side contains the result of type [Type] if successful
  Future<Either<Failure, Type>> call(Params params);
}

/// Used when a use case doesn't require any parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
