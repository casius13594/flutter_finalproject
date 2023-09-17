import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    bool isMe = APIs.user.uid == widget.message.SenderId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet();
        },
        child: isMe ? _blueMessage() : _blackMessage());
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
                    style: const TextStyle(fontSize: 15, color: Colors.white),
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
                    style: const TextStyle(fontSize: 15, color: Colors.white),
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

  void _showBottomSheet() {
    int itemCount = 3;
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            height: ms.height * 0.15,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                Container(
                  width: ms.width * (1 / itemCount),
                  child: _OptionItem(
                      icon: Icon(Icons.copy_all_outlined,
                          color: Colors.blueAccent, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.content))
                            .then((value) {
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Text Copied'),
                            ),
                          );
                        });
                      }),
                ),
                Container(
                  width: ms.width * (1 / itemCount),
                  child: _OptionItem(
                      icon: Icon(Icons.delete_forever_outlined,
                          color: Colors.red, size: 26),
                      name: 'Delete Messafe',
                      onTap: () async {
                        await APIs.deleteMessage(widget.message).then((value) {
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Delete'),
                            ),
                          );
                        });
                      }),
                ),
                Container(
                  width: ms.width * (1 / itemCount),
                  child: _OptionItem(
                      icon:
                          Icon(Icons.info, color: Colors.blueAccent, size: 26),
                      name: 'Info ',
                      onTap: () {
                        _showInfoPopup(context, widget.message);
                      }),
                ),
              ],
            ),
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
          left: ms.width * 0.05,
          top: ms.height * 0.015,
          bottom: ms.height * 0.025,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            SizedBox(
                height:
                    4), // Adjust the spacing between the icon and text as needed
            Text(name),
          ],
        ),
      ),
    );
  }
}

class InfoPopup extends StatelessWidget {
  final Message message;

  InfoPopup({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Info'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Sent At: ${MyDateUtil.getFormattedTime(context: context, time: message.sentTime)}'),
          SizedBox(height: 8), // Add spacing between the lines
          message.readTime.isNotEmpty
              ? Text(
                  'Read At: ${MyDateUtil.getFormattedTime(context: context, time: message.sentTime)}')
              : Text('Not seen'), // Add another line of content
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dial
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

void _showInfoPopup(BuildContext context, Message message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return InfoPopup(message: message); // Pass the message here
    },
  );
}
