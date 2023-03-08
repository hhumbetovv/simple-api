import 'package:intl/intl.dart';

String getFullDate() {
  return '${DateFormat.yMd().format(DateTime.now())} ${DateFormat.Hms().format(DateTime.now())}';
}

String getFullHour() {
  return DateFormat.Hms().format(DateTime.now());
}
