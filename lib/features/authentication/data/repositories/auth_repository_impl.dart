import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    // Check network connectivity
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      // Attempt login via remote data source
      final userModel = await remoteDataSource.login(username, password);

      // Cache the token
      if (userModel.token != null) {
        await localDataSource.cacheToken(userModel.token!);
      }

      // Cache the user data
      await localDataSource.cacheUser(userModel);

      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on CacheException catch (e) {
      // Login succeeded but caching failed - still return success
      // but log the cache error
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error during login: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> register(UserRegistration registration) async {
    // Check network connectivity
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('No internet connection'));
    }

    try {
      // Prepare user data for registration
      final userData = _prepareRegistrationData(registration);

      // Attempt registration via remote data source
      final userModel = await remoteDataSource.register(userData);

      // Cache the user data (no token on registration in FakeStoreAPI)
      await localDataSource.cacheUser(userModel);

      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on CacheException catch (e) {
      // Registration succeeded but caching failed - still return success
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error during registration: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Clear local authentication data
      await localDataSource.clearAuthData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error during logout: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try to get cached user
      final cachedUser = await localDataSource.getCachedUser();

      if (cachedUser != null) {
        return Right(cachedUser);
      } else {
        return const Left(CacheFailure('No user is currently logged in'));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Unexpected error retrieving user: $e'));
    }
  }

  /// Helper method to prepare registration data
  Map<String, dynamic> _prepareRegistrationData(UserRegistration registration) {
    final data = <String, dynamic>{
      'username': registration.username,
      'email': registration.email,
      'password': registration.password,
    };

    // Add optional name fields
    if (registration.firstname != null || registration.lastname != null) {
      data['name'] = {
        'firstname': registration.firstname ?? '',
        'lastname': registration.lastname ?? '',
      };
    }

    // Add optional phone
    if (registration.phone != null) {
      data['phone'] = registration.phone;
    }

    // Add optional address fields
    if (registration.city != null ||
        registration.street != null ||
        registration.number != null ||
        registration.zipcode != null) {
      data['address'] = {
        'city': registration.city ?? '',
        'street': registration.street ?? '',
        'number': registration.number ?? 0,
        'zipcode': registration.zipcode ?? '',
      };
    }

    return data;
  }
}
