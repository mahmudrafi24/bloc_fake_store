import 'package:equatable/equatable.dart';
import 'package:fake_store/features/authentication/domain/repositories/auth_repository.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to request user login
class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

/// Event to request user registration
class RegisterRequested extends AuthEvent {
  final UserRegistration registration;

  const RegisterRequested({required this.registration});

  @override
  List<Object?> get props => [registration];
}

/// Event to request user logout
class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

/// Event to check current authentication status
class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}
