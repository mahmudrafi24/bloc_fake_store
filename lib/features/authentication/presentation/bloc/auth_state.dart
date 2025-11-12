import 'package:equatable/equatable.dart';
import 'package:fake_store/features/authentication/domain/entities/user.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any authentication action
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when authentication operation is in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is successfully authenticated
class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// State when authentication operation fails
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
