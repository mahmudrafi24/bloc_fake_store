import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fake_store/core/errors/failures.dart';
import 'package:fake_store/core/usecases/usecase.dart';
import 'package:fake_store/features/authentication/domain/entities/user.dart';
import 'package:fake_store/features/authentication/domain/repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase extends UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}

/// Parameters for login use case
class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
