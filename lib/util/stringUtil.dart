import 'package:intl/intl.dart';

class StringUtil {
  static String formatCamelCase(String text) {
    return text
        .replaceAllMapped(
            RegExp(r'([a-z])([A-Z])'), (match) => '${match[1]} ${match[2]}')
        .replaceFirstMapped(
            RegExp(r'^[a-z]'), (match) => match[0]!.toUpperCase());
  }

  static String getFormattedAmount(double amount) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: 'Rp ');
    return formatter.format(amount);
  }

  static double calculateDifferencePercentage(double previous, double current) {
    if (previous == 0) return 100; // avoid division by zero
    return ((current - previous) / previous) * 100;
  }

  static String differenceLabel(double current, double previous) {
    if (current > previous) {
      return '↑';
    } else if (current < previous) {
      return '↓';
    } else {
      return '–';
    }
  }

  static String formatYAxisLabel(double value, double maxY) {
  if (maxY >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  } else if (maxY >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)}K';
  } else {
    return value.toStringAsFixed(0);
  }
}

}
