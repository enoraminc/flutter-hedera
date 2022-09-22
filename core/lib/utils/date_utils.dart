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
