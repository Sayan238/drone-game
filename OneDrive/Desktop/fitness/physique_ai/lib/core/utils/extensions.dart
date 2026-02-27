import 'package:intl/intl.dart';

extension StringExtension on String {
  String get capitalize =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase =>
      split(' ').map((word) => word.capitalize).join(' ');
}

extension DoubleExtension on double {
  String toFixed(int decimals) => toStringAsFixed(decimals);

  String get formatCalories => NumberFormat('#,##0').format(this);
}

extension DateTimeExtension on DateTime {
  String get formatted => DateFormat('MMM dd, yyyy').format(this);

  String get shortDate => DateFormat('dd/MM').format(this);

  String get dayName => DateFormat('EEE').format(this);

  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
