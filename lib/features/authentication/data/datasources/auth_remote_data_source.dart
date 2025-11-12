import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/user_model.dart';
import 'package:dio/dio.dart';

/// Abstract interface for authentication remote data source
abstract class AuthRemoteDataSource {
  /// Login with username and password
  /// Returns UserModel with authentication token
  /// Throws [ServerException] if login fails
  Future<UserModel> login(String username, String password);

  /// Register a new user
  /// Returns UserModel without token (FakeStoreAPI doesn't return token on registration)
  /// Throws [ServerException] if registration fails
  Future<UserModel> register(Map<String, dynamic> userData);
}

/// Implementation of AuthRemoteDataSource using ApiClient
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await apiClient.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 201) {
        // FakeStoreAPI returns a token on successful login
        final token = response.data['token'];

        // Since FakeStoreAPI doesn't return user details on login,
        // we need to create a minimal user model with the token
        // In a real app, you would fetch user details after login
        return UserModel(
          id: 0, // Placeholder - will be updated when fetching user details
          username: username,
          email: '', // Placeholder
          token: token,
        );
      } else {
        throw ServerException('Login failed', statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.data['message'] ?? 'Login failed',
          statusCode: e.response?.statusCode,
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Login failed: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error during login: $e');
    }
  }

  @override
  Future<UserModel> register(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post(ApiConstants.users, data: userData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // FakeStoreAPI returns the created user
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException(
          e.response?.data['message'] ?? 'Registration failed',
          statusCode: e.response?.statusCode,
        );
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw ServerException('Unexpected error during registration: $e');
    }
  }
}
