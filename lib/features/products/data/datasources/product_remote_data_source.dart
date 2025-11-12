import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/product_model.dart';

/// Abstract interface for product remote data source
abstract class ProductRemoteDataSource {
  /// Fetch all products from the API
  /// Throws [ServerException] if the request fails
  Future<List<ProductModel>> getProducts();

  /// Fetch a single product by ID from the API
  /// Throws [ServerException] if the request fails
  Future<ProductModel> getProductById(int id);

  /// Fetch all available categories from the API
  /// Throws [ServerException] if the request fails
  Future<List<String>> getCategories();

  /// Fetch products by category from the API
  /// Throws [ServerException] if the request fails
  Future<List<ProductModel>> getProductsByCategory(String category);
}

/// Implementation of ProductRemoteDataSource using ApiClient
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient apiClient;

  ProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await apiClient.get(ApiConstants.products);

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data as List<dynamic>;
        return productsJson
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to fetch products',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        _handleDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await apiClient.get('${ApiConstants.products}/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          'Failed to fetch product with id $id',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        _handleDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await apiClient.get(ApiConstants.products);

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = response.data as List<dynamic>;
        return categoriesJson.map((category) => category as String).toList();
      } else {
        throw ServerException(
          'Failed to fetch categories',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        _handleDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await apiClient.get(
        '${ApiConstants.products}/category/$category',
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data as List<dynamic>;
        return productsJson
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          'Failed to fetch products for category $category',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        _handleDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  /// Handle DioException and return appropriate error message
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Bad response: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error';
      case DioExceptionType.badCertificate:
        return 'Bad certificate';
      case DioExceptionType.unknown:
        return 'Unknown error: ${error.message}';
    }
  }
}
