import 'package:intl/intl.dart';

class StringUtil {
  static String formatCamelCase(String text) {
    return text
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match[1]} ${match[2]}')
        .replaceFirstMapped(RegExp(r'^[a-z]'), (match) => match[0]!.toUpperCase());
  }

    static String getFormattedAmount(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: 'Rp ');
    return formatter.format(amount);
  }
}