import 'package:intl/intl.dart';

class DateFormatter {
  static String formatFullDateTime(DateTime dateTime) {
    
    return DateFormat('dd \'de\' MMMM \'de\' yyyy, hh:mm a', 'es_ES').format(dateTime);
  }

  static String formatShortDate(DateTime dateTime) {
    
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}