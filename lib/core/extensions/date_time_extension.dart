import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String formatDate() {
    return DateFormat('d MMM yyyy').format(this);
  }
}
