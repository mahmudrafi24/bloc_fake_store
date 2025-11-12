import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/hive_service.dart';
import '../models/user_model.dart';

/// Abstract interface for authentication local data source
abstract class AuthLocalDataSource {
  /// Store authentication token
  /// Throws [CacheException] if storage fails
  Future<void> cacheToken(String token);

  /// Retrieve authentication token
  /// Returns null if no token is stored
  /// Throws [CacheException] if retrieval fails
  Future<String?> getToken();

  /// Store user data
  /// Throws [CacheException] if storage fails
  Future<void> cacheUser(UserModel user);

  /// Retrieve cached user data
  /// Returns null if no user is cached
  /// Throws [CacheException] if retrieval fails
  Future<UserModel?> getCachedUser();

  /// Clear all authentication data (token and user)
  /// Used during logout
  /// Throws [CacheException] if clearing fails
  Future<void> clearAuthData();
}

/// Implementation of AuthLocalDataSource using Hive
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final HiveService hiveService;

  // Keys for storing data
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'current_user';

  AuthLocalDataSourceImpl({required this.hiveService});

  @override
  Future<void> cacheToken(String token) async {
    try {
      final box = await hiveService.getBox<String>(HiveBoxNames.authToken);
      await box.put(_tokenKey, token);
    } catch (e) {
      throw CacheException('Failed to cache authentication token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      final box = await hiveService.getBox<String>(HiveBoxNames.authToken);
      return box.get(_tokenKey);
    } catch (e) {
      throw CacheException('Failed to retrieve authentication token: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final box = await hiveService.getBox<UserModel>(HiveBoxNames.users);
      await box.put(_userKey, user);
    } catch (e) {
      throw CacheException('Failed to cache user data: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final box = await hiveService.getBox<UserModel>(HiveBoxNames.users);
      return box.get(_userKey);
    } catch (e) {
      throw CacheException('Failed to retrieve cached user: $e');
    }
  }

  @override
  Future<void> clearAuthData() async {
    try {
      // Clear token
      final tokenBox = await hiveService.getBox<String>(HiveBoxNames.authToken);
      await tokenBox.delete(_tokenKey);

      // Clear user data
      final userBox = await hiveService.getBox<UserModel>(HiveBoxNames.users);
      await userBox.delete(_userKey);
    } catch (e) {
      throw CacheException('Failed to clear authentication data: $e');
    }
  }
}
