import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$ ',
    decimalDigits: 2,
  );

  static String format(double? value) {
    if (value == null) return 'R\$ 0,00';
    return _currencyFormat.format(value);
  }

  static String formatCompact(double? value) {
    if (value == null) return 'R\$ 0';
    
    if (value >= 1000000) {
      return 'R\$ ${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}K';
    }
    
    return format(value);
  }

  static double? parseFromString(String value) {
    // Remove currency symbols and convert comma to dot
    final cleanValue = value
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    
    return double.tryParse(cleanValue);
  }
}