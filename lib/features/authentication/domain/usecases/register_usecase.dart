import 'package:dartz/dartz.dart';
import 'package:fake_store/core/errors/failures.dart';
import 'package:fake_store/core/usecases/usecase.dart';
import 'package:fake_store/features/authentication/domain/entities/user.dart';
import 'package:fake_store/features/authentication/domain/repositories/auth_repository.dart';

/// Use case for user registration
class RegisterUseCase extends UseCase<User, UserRegistration> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(UserRegistration params) async {
    return await repository.register(params);
  }
}
