/// Base class for all exceptions in the application
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when server returns an error
class ServerException extends AppException {
  final int? statusCode;

  ServerException(String message, {this.statusCode}) : super(message);

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Exception thrown when cache operations fail
class CacheException extends AppException {
  CacheException(String message) : super(message);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception thrown when network connectivity issues occur
class NetworkException extends AppException {
  NetworkException(String message) : super(message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception thrown when input validation fails
class ValidationException extends AppException {
  final Map<String, String>? errors;

  ValidationException(String message, {this.errors}) : super(message);

  @override
  String toString() => 'ValidationException: $message';
}
