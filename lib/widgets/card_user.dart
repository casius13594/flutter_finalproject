import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/apis/apis.dart';
import 'package:flutter_finalproject/models/chat_user.dart';
import 'package:flutter_finalproject/pages/chat_page.dart';
import '../pages/message_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/message.dart';

class ChatUser extends StatefulWidget {
  final ChatUserProfile user;
  const ChatUser({super.key, required this.user});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatPage(user: widget.user)),
          );
        },
        child: StreamBuilder(
            stream: APIs.getLastMess(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                _message = list[0];
              }
              return ListTile(
                leading: ClipRRect(
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
                title: Text(widget.user.name),
                subtitle: Text(
                  _message != null ? _message!.content : widget.user.lastMess,
                  maxLines: 1,
                ),
                trailing: _message == null
                    ? null
                    : Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
              );
            }),
      ),
    );
  }
}
