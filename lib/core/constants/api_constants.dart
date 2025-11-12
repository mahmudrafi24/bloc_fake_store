class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://fakestoreapi.com';

  // Endpoints
  static const String products = '/products';
  static const String categories = '/products/categories';
  static const String login = '/auth/login';
  static const String users = '/users';
  static const String carts = '/carts';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Cache duration
  static const Duration cacheDuration = Duration(hours: 1);
}
