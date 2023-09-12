import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(
      {required BuildContext context, required time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sentTimeFor =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sentTimeFor.day &&
        now.month == sentTimeFor.month &&
        now.year == sentTimeFor.year) {
      return TimeOfDay.fromDateTime(sentTimeFor).format(context);
    }
    return '${sentTimeFor.day}/${_getMonth(sentTimeFor)}';
  }

  static String _getMonth(DateTime date) {
    if (date.month < 10) {
      return '0' + '${date.month}';
    } else
      return '${date.month}';
  }
}
