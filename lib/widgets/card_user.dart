import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/models/chat_user.dart';
import '../pages/message_page.dart';

class ChatUser extends StatefulWidget {
  final ChatUserProfile user;
  const ChatUser({super.key, required this.user});

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: ListTile(
          leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
          title: Text(widget.user.name),
          //last message
          subtitle: Text(
            widget.user.lastMess,
            maxLines: 1,
          ),
          //time
          trailing: Text('1:00 PM', style: TextStyle(color: Colors.black26)),
        ),
      ),
    );
  }
}
