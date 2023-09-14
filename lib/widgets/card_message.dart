import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
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
          child: widget.message.type == Type.text
              ? Container(
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
                )
              : Container(
                  padding: EdgeInsets.all(ms.width * .01),
                  margin: EdgeInsets.symmetric(
                      horizontal: ms.width * .06, vertical: ms.height * .01),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ms.height * .03),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.content,
                      placeholder: (context, url) => const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _blackMessage() {
    if (widget.message.readTime.isEmpty) {
      print('Updating read_time for message: ${widget.message.sentTime}');
      APIs.updateMessStatus(widget.message);
      log('message read updated');
    } else {
      print(
          'Message readTime is empty for message: ${widget.message.sentTime}');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: widget.message.type == Type.text
              ? Container(
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
                )
              : Container(
                  padding: EdgeInsets.all(ms.width * .03),
                  margin: EdgeInsets.symmetric(
                      horizontal: ms.width * .04, vertical: ms.height * .01),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ms.height * .03),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.content,
                      placeholder: (context, url) => const Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.image, size: 70),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
        ),
        Row(
          children: [
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
