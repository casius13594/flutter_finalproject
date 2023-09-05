import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/models/chat_user.dart';
import 'package:flutter_finalproject/pages/message_page.dart';
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
  bool isTextFieldExpanded = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(children: [
          Expanded(
            child: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //check data loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  // return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    //final data = snapshot.data?.docs;
                    //list = data
                    //       ?.map((e) => ChatUserProfile.fromJson(e.data()))
                    //        .toList() ??
                    //    [];
                    final _list = ['hi', 'hello'];
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: ms.height * 0.02),
                          itemBuilder: (context, index) {
                            return Text('Message: ${_list[index]}');
                          });
                    } else {
                      return const Center(
                        child: Text('No connection',
                            style: TextStyle(fontSize: 20)),
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

  Widget _chatInput() {
    return Row(children: [
      Expanded(
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon:
                    const Icon(Icons.emoji_emotions, color: Colors.blueAccent),
              ),
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
                  : Row(children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.camera_alt,
                            color: Colors.blueAccent),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.photo_library,
                            color: Colors.blueAccent),
                      ),
                    ]),
            ],
          ),
        ),
      )
    ]);
  }
}
