import 'package:flutter/material.dart';

/// Extension methods for String class
extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  ///
  /// Example: "hello" -> "Hello"
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter of each word
  ///
  /// Example: "hello world" -> "Hello World"
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Truncates string to specified length with ellipsis
  ///
  /// Example: "Hello World".truncate(5) -> "Hello..."
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Removes all whitespace from string
  String removeWhitespace() {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Checks if string is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Checks if string is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;
}

/// Extension methods for DateTime class
extension DateTimeExtensions on DateTime {
  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Checks if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Returns time ago string
  ///
  /// Example: "2 hours ago", "3 days ago"
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  /// Returns date only (without time)
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }

  /// Adds days to date
  DateTime addDays(int days) {
    return add(Duration(days: days));
  }

  /// Subtracts days from date
  DateTime subtractDays(int days) {
    return subtract(Duration(days: days));
  }
}

/// Extension methods for BuildContext class
extension BuildContextExtensions on BuildContext {
  /// Returns the current theme
  ThemeData get theme => Theme.of(this);

  /// Returns the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Returns the screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Returns the screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Returns the screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Checks if device is in portrait mode
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Checks if device is in landscape mode
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Shows a snackbar with message
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Shows an error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Shows a success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Hides the keyboard
  void hideKeyboard() {
    FocusScope.of(this).unfocus();
  }

  /// Checks if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  /// Returns the safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Checks if device is mobile (width < 600)
  bool get isMobile => screenWidth < 600;

  /// Checks if device is tablet (width >= 600 && width < 1200)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Checks if device is desktop (width >= 1200)
  bool get isDesktop => screenWidth >= 1200;
}

/// Extension methods for num class
extension NumExtensions on num {
  /// Converts number to currency string
  String toCurrency({String symbol = '\$'}) {
    return '$symbol${toStringAsFixed(2)}';
  }

  /// Checks if number is positive
  bool get isPositive => this > 0;

  /// Checks if number is negative
  bool get isNegative => this < 0;

  /// Checks if number is zero
  bool get isZero => this == 0;
}
