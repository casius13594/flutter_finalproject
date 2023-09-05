import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/models/chat_user.dart';
import 'package:flutter_finalproject/models/message.dart';
import 'package:flutter_finalproject/pages/message_page.dart';
import 'package:flutter_finalproject/widgets/card_message.dart';
import '../models/chat_user.dart';
import '../widgets/card_user.dart';
import '../apis/apis.dart';

class ChatPage extends StatefulWidget {
  final ChatUserProfile user;
  const ChatPage({super.key, required this.user});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> _list = [];
  bool isTextFieldExpanded = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        body: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: APIs.getAllMess(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //check data loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  // return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    //list = data
                    //       ?.map((e) => ChatUserProfile.fromJson(e.data()))
                    //        .toList() ??
                    //    [];
                    _list.clear();
                    _list.add(Message(
                        sentTime: '10:00pm',
                        ToID: 'xyz',
                        type: Type.text,
                        SenderId: APIs.user.uid,
                        content: 'HI',
                        readTime: ''));
                    _list.add(Message(
                        sentTime: '10:00pm',
                        ToID: APIs.user.uid,
                        type: Type.text,
                        SenderId: 'xyz',
                        content: 'Hey there',
                        readTime: ''));

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: ms.height * 0.02),
                          itemBuilder: (context, index) {
                            return CardMessage(message: _list[index]);
                          });
                    } else {
                      return const Center(
                        child: Text('Welcome', style: TextStyle(fontSize: 20)),
                      );
                    }
                }
              },
            ),
          ),
          _chatInput()
        ]),
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
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 13, color: Colors.green),
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

  Widget _chatInput() {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.emoji_emotions, color: Colors.blueAccent),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          isTextFieldExpanded = text.isNotEmpty;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                isTextFieldExpanded
                    ? IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send, color: Colors.blueAccent),
                      )
                    : Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.blueAccent,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.photo_library,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
