import 'package:intl/intl.dart';

/// Currency formatting utilities for Kenyan Shillings (KES)
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format amount as KES with proper thousand separators
  /// e.g., 1234567.89 -> "1,234,567.89 KSh"
  static String formatKES(double amount) {
    final formatter = NumberFormat('#,##0.00', 'en_KE');
    return '${formatter.format(amount)} KSh';
  }

  /// Format amount as KES without decimals
  /// e.g., 1234567.89 -> "1,234,568 KSh"
  static String formatKESWhole(double amount) {
    final formatter = NumberFormat('#,##0', 'en_KE');
    return '${formatter.format(amount.round())} KSh';
  }

  /// Format amount as KES with compact notation for large numbers
  /// e.g., 1234567.89 -> "1.23M KSh"
  static String formatKESCompact(double amount) {
    final formatter = NumberFormat.compact(locale: 'en_KE');
    return '${formatter.format(amount)} KSh';
  }

  /// Parse a KES string back to double
  /// Handles "1,234.56 KSh" or "1234.56" formats
  static double? parseKES(String value) {
    final cleaned = value
        .replaceAll('KSh', '')
        .replaceAll('KES', '')
        .replaceAll(',', '')
        .trim();
    return double.tryParse(cleaned);
  }
}
