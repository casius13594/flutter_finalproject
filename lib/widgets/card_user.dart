import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/message_page.dart';

class ChatUser extends StatefulWidget {
  const ChatUser({super.key});

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
          title: Text('Demo User'),
          //last message
          subtitle: Text(
            'Last user message',
            maxLines: 1,
          ),
          //time
          trailing: Text('1:00 PM', style: TextStyle(color: Colors.black26)),
        ),
      ),
    );
  }
}
