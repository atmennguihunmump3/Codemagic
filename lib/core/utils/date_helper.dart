import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class DateHelper {
  static String formatDate(DateTime d) => DateFormat(AppConstants.dateFormat).format(d);
  static String formatDisplay(DateTime d) => DateFormat(AppConstants.dateDisplayFormat).format(d);

  static DateTime startOfWeek(DateTime d) {
    final diff = d.weekday - 1;
    return DateTime(d.year, d.month, d.day - diff);
  }

  static DateTime endOfWeek(DateTime d) {
    final start = startOfWeek(d);
    return start.add(const Duration(days: 6, hours: 23, minutes: 59));
  }

  static List<DateTime> daysInRange(DateTime from, int days) {
    return List.generate(days, (i) => DateTime(from.year, from.month, from.day + i));
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}