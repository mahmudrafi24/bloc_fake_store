import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fake_store/core/network/api_client.dart';
import 'package:fake_store/core/network/network_info.dart';
import 'package:fake_store/core/storage/hive_service.dart';
import 'package:fake_store/injection_container.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dependency Injection Container', () {
    setUp(() async {
      // Reset GetIt before each test
      await sl.reset();
      // Initialize Hive for testing with a temporary directory
      Hive.init('./test/hive_test_db');
    });

    tearDown(() async {
      // Clean up Hive after tests
      await Hive.deleteFromDisk();
    });

    test('should register all core dependencies', () async {
      // Act
      await init();

      // Assert - Core services should be registered
      expect(sl.isRegistered<ApiClient>(), true);
      expect(sl.isRegistered<NetworkInfo>(), true);
      expect(sl.isRegistered<HiveService>(), true);
      expect(sl.isRegistered<Dio>(), true);
      expect(sl.isRegistered<Connectivity>(), true);
    });

    test('should return same instance for lazy singletons', () async {
      // Arrange
      await init();

      // Act
      final apiClient1 = sl<ApiClient>();
      final apiClient2 = sl<ApiClient>();

      // Assert - Should be the same instance
      expect(identical(apiClient1, apiClient2), true);
    });

    test('should resolve ApiClient with Dio dependency', () async {
      // Arrange
      await init();

      // Act
      final apiClient = sl<ApiClient>();

      // Assert
      expect(apiClient, isNotNull);
      expect(apiClient, isA<ApiClient>());
    });

    test('should resolve NetworkInfo with Connectivity dependency', () async {
      // Arrange
      await init();

      // Act
      final networkInfo = sl<NetworkInfo>();

      // Assert
      expect(networkInfo, isNotNull);
      expect(networkInfo, isA<NetworkInfo>());
    });

    test('should resolve HiveService', () async {
      // Arrange
      await init();

      // Act
      final hiveService = sl<HiveService>();

      // Assert
      expect(hiveService, isNotNull);
      expect(hiveService, isA<HiveService>());
    });
  });
}
