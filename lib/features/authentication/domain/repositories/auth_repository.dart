// ignore_for_file: unintended_html_in_doc_comment

import 'package:dartz/dartz.dart';
import 'package:fake_store/core/errors/failures.dart';
import 'package:fake_store/features/authentication/domain/entities/user.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Authenticate user with username and password
  /// Returns Either<Failure, User> with authenticated user on success
  Future<Either<Failure, User>> login(String username, String password);

  /// Register a new user account
  /// Returns Either<Failure, User> with created user on success
  Future<Either<Failure, User>> register(UserRegistration registration);

  /// Log out the current user
  /// Returns Either<Failure, void> on success
  Future<Either<Failure, void>> logout();

  /// Get the currently authenticated user
  /// Returns Either<Failure, User> with current user on success
  Future<Either<Failure, User>> getCurrentUser();
}

/// User registration data transfer object
class UserRegistration {
  final String username;
  final String email;
  final String password;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final String? city;
  final String? street;
  final int? number;
  final String? zipcode;

  const UserRegistration({
    required this.username,
    required this.email,
    required this.password,
    this.firstname,
    this.lastname,
    this.phone,
    this.city,
    this.street,
    this.number,
    this.zipcode,
  });
}
