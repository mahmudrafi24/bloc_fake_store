import 'package:intl/intl.dart';

/// Utility class for formatting data
class Formatters {
  Formatters._();

  /// Formats price with currency symbol
  ///
  /// Example: 19.99 -> $19.99
  static String formatPrice(double price, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(price);
  }

  /// Formats price without currency symbol
  ///
  /// Example: 19.99 -> 19.99
  static String formatPriceWithoutSymbol(double price) {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(price);
  }

  /// Formats date to readable string
  ///
  /// Example: 2024-01-15 -> Jan 15, 2024
  static String formatDate(DateTime date) {
    final formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  /// Formats date with time
  ///
  /// Example: 2024-01-15 14:30 -> Jan 15, 2024 at 2:30 PM
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('MMM dd, yyyy \'at\' h:mm a');
    return formatter.format(dateTime);
  }

  /// Formats date to short format
  ///
  /// Example: 2024-01-15 -> 01/15/2024
  static String formatDateShort(DateTime date) {
    final formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(date);
  }

  /// Formats time only
  ///
  /// Example: 14:30 -> 2:30 PM
  static String formatTime(DateTime dateTime) {
    final formatter = DateFormat('h:mm a');
    return formatter.format(dateTime);
  }

  /// Formats number with thousand separators
  ///
  /// Example: 1000 -> 1,000
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  /// Formats rating with one decimal place
  ///
  /// Example: 4.567 -> 4.6
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }

  /// Formats percentage
  ///
  /// Example: 0.15 -> 15%
  static String formatPercentage(double value) {
    final percentage = (value * 100).toStringAsFixed(0);
    return '$percentage%';
  }
}
