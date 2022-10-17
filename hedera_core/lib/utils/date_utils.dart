import 'package:intl/intl.dart';

class CustomDateUtils {
  static String simpleFormat(DateTime? dateTime) {
    if (dateTime == null) return "-";
    final DateFormat df = DateFormat('dd/MM/yyyy');

    return df.format(dateTime);
  }

  static String simpleFormatWithTime(DateTime? dateTime) {
    if (dateTime == null) return "-";
    final DateFormat df = DateFormat('dd/MM/yyyy HH:mm:ss');

    return df.format(dateTime);
  }

  static String monthOnly(DateTime? dateTime) {
    if (dateTime == null) return "-";
    final DateFormat df = DateFormat('MMMM yyyy');

    return df.format(dateTime);
  }

  static isoStringToDateFormat(String isoDateString) {
    // DateFormat df = DateFormat('dd/MM/yyyy HH:mm');

    final DateFormat df = DateFormat('dd MMMM yyyy');
    if (DateTime.tryParse(isoDateString) != null) {
      return df.format(DateTime.tryParse(isoDateString)!);
    } else {
      return null;
    }
  }

  static isoStringToDateFormatWithTime(String isoDateString) {
    DateFormat df = DateFormat('dd/MM/yyyy HH:mm:ss');

    if (DateTime.tryParse(isoDateString) != null) {
      DateTime date = DateTime.tryParse(isoDateString)!;
      if (isoDateString.contains("+")) {
        final hours =
            int.tryParse(isoDateString.split("+")[1].replaceAll("0", "")) ?? 0;
        date = date.add(Duration(hours: hours));
        // print("============");
        // print(isoDateString);
        // print(hours);
        // print(date.toString());
        // print("============");
      }

      return df.format(date);
    } else {
      return null;
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime get firstDayOfWeek => subtract(Duration(days: weekday - 1));

  DateTime get lastDayOfWeek =>
      add(Duration(days: DateTime.daysPerWeek - weekday));

  DateTime get lastDayOfMonth =>
      month < 12 ? DateTime(year, month + 1, 0) : DateTime(year + 1, 1, 0);
}
