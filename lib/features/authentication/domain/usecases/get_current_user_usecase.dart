import 'package:dartz/dartz.dart';
import 'package:fake_store/core/errors/failures.dart';
import 'package:fake_store/core/usecases/usecase.dart';
import 'package:fake_store/features/authentication/domain/entities/user.dart';
import 'package:fake_store/features/authentication/domain/repositories/auth_repository.dart';

/// Use case for getting the current authenticated user
class GetCurrentUserUseCase extends UseCase<User, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
