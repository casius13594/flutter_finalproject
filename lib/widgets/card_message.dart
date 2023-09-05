import 'package:flutter/material.dart';
import 'package:flutter_finalproject/utilities/dateutil.dart';
import 'package:get/get.dart';
import '../models/message.dart';
import '../apis/apis.dart';
import '../pages/message_page.dart';

class CardMessage extends StatefulWidget {
  final Message message;
  const CardMessage({super.key, required this.message});
  @override
  State<CardMessage> createState() => _CardMessageState();
}

class _CardMessageState extends State<CardMessage> {
  @override
  Widget build(BuildContext context) {
    return widget.message.SenderId == APIs.user.uid
        ? _blueMessage()
        : _blackMessage();
  }

  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: ms.width * .04),
            if (widget.message.readTime.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
            const SizedBox(width: 2),
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sentTime),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(ms.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: ms.width * .04, vertical: ms.height * .01),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            child: Text(
              widget.message.content,
              style: const TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }

  Widget _blackMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(ms.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: ms.width * .04, vertical: ms.height * .01),
            decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Text(
              widget.message.content,
              style: const TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ),
        ),
        Row(
          children: [
            if (widget.message.readTime.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
            const SizedBox(width: 2),
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sentTime),
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            SizedBox(width: ms.width * .04),
          ],
        ),
      ],
    );
  }
}
