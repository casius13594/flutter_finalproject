import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:flutter_finalproject/widgets/card_user.dart';
import '../apis/apis.dart';

late Size ms;

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<StatefulWidget> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
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
          stream: APIs.firestore.collection('users').snapshots(),
          builder: (context, snapshot) {
            final list = [];
            if (snapshot.hasData) {
              final data = snapshot.data?.docs;
              for (var i in data!) {
                log('Data:${i.data()}');
                list.add(i.data()['name']);
              }
            }
            return ListView.builder(
                itemCount: list.length,
                padding: EdgeInsets.only(top: ms.height * 0.02),
                itemBuilder: (context, index) {
                  return Text('Name: ${list[index]}');
                });
          },
        ));
  }
}
