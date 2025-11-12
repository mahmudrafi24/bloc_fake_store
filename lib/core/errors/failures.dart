import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure when server returns an error
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// Failure when local cache operations fail
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// Failure when network connectivity issues occur
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

/// Failure when input validation fails
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}
