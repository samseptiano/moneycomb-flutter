class StringUtil {
  static String formatCamelCase(String text) {
    return text
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match[1]} ${match[2]}')
        .replaceFirstMapped(RegExp(r'^[a-z]'), (match) => match[0]!.toUpperCase());
  }
}