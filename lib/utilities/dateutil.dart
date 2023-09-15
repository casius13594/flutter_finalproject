import 'dart:developer';
import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(
      {required BuildContext context, required time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(date).format(context);
    if (now.day == date.day &&
        now.month == date.month &&
        now.year == date.year) {
      return formattedTime;
    }

    return now.year == date.year
        ? '$formattedTime - ${date.day}/${_getMonth(date)}'
        : '$formattedTime - ${date.day}/${_getMonth(date)} ${date.year}';
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

  static String getLastActiveTime(
      {required BuildContext context, required String lastseen}) {
    log('Last seen: $lastseen');
    DateTime time = DateTime.fromMicrosecondsSinceEpoch(int.parse(lastseen));
    DateTime now = DateTime.now();
    String formattedTime = TimeOfDay.fromDateTime(time).format(context);

    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Last seen at $formattedTime';
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }
    return 'Last seen on ${time.day}/${time.month} on $formattedTime';
  }
}
