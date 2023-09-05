import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(
      {required BuildContext context, required time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}
