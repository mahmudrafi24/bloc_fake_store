import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio}) {
    _configureDio();
  }

  void _configureDio() {
    dio.options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(
        milliseconds: ApiConstants.connectionTimeout,
      ),
      receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add request interceptor for authentication and logging
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log request
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('REQUEST DATA: ${options.data}');

          // Add authentication token if available
          // Token will be added by the repository layer when needed

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          print('RESPONSE DATA: ${response.data}');

          return handler.next(response);
        },
        onError: (error, handler) {
          // Log error
          print(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          print('ERROR MESSAGE: ${error.message}');

          return handler.next(error);
        },
      ),
    );
  }

  /// Perform GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// Perform POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// Perform PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// Perform DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// Add authentication token to headers
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication token from headers
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}
