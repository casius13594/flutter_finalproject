import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/models/chat_user.dart';
import 'package:flutter_finalproject/pages/message_page.dart';
import '../models/chat_user.dart';
import '../widgets/card_user.dart';

class ChatPage extends StatefulWidget {
  final ChatUserProfile user;
  const ChatPage({super.key, required this.user});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Align content at the ends
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(ms.height * .03),
              child: CachedNetworkImage(
                width: ms.height * .055,
                height: ms.height * .055,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) => const CircleAvatar(
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 13, color: Colors.amberAccent),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            // Handle the info button action
          },
          icon: const Icon(
            Icons.info,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
