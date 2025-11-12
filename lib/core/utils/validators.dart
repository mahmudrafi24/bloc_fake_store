/// Utility class for input validation
class Validators {
  Validators._();

  /// Validates email format
  ///
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password strength
  ///
  /// Returns null if valid, error message if invalid
  /// Password must be at least 6 characters long
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }

    return null;
  }

  /// Validates phone number format
  ///
  /// Returns null if valid, error message if invalid
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove common formatting characters
    final cleanedValue = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it contains only digits and is between 10-15 characters
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');

    if (!phoneRegex.hasMatch(cleanedValue)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validates username
  ///
  /// Returns null if valid, error message if invalid
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }

    return null;
  }

  /// Validates required field
  ///
  /// Returns null if valid, error message if invalid
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  /// Validates quantity (must be positive integer)
  ///
  /// Returns null if valid, error message if invalid
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }

    final quantity = int.tryParse(value);
    if (quantity == null || quantity <= 0) {
      return 'Please enter a valid quantity';
    }

    return null;
  }
}
