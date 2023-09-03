import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_finalproject/models/chat_user.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:flutter_finalproject/widgets/card_user.dart';
import '../apis/apis.dart';
import 'dart:convert';

late Size ms;

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<ChatUserProfile> list = [];
  @override
  Widget build(BuildContext context) {
    ms = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          title: Text(
            'Message',
            style:
                TextStyle(color: Theme.of(context).colorScheme.surfaceVariant),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          automaticallyImplyLeading: false,
        ),
        body: StreamBuilder(
          stream: APIs.getAllUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              //check data loading
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;
                list = data
                        ?.map((e) => ChatUserProfile.fromJson(e.data()))
                        .toList() ??
                    [];
                return ListView.builder(
                    itemCount: list.length,
                    padding: EdgeInsets.only(top: ms.height * 0.02),
                    itemBuilder: (context, index) {
                      return ChatUser(user: list[index]);
                    });
            }
          },
        ));
  }
}
