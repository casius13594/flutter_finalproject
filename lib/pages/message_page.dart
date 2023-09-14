import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final List<ChatUserProfile> _searchList = [];
  bool _checkSearch = false;
  @override
  void initState() {
    super.initState();
    APIs.updateStatusActive(true);

    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume')) {
        APIs.updateStatusActive(true);
      }
      if (message.toString().contains('pause')) {
        APIs.updateStatusActive(false);
      }
      if (message.toString().contains('inactive')) {
        APIs.updateStatusActive(false);
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    ms = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _checkSearch = !_checkSearch;
                  });
                },
                icon: Icon(_checkSearch
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
              ),
              Expanded(
                child: _checkSearch
                    ? TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tìm kiếm',
                          hintStyle: TextStyle(
                            color: Colors
                                .white30, // Set the hint text color to white
                          ),
                        ),
                        autofocus: true,
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            color: Colors.white),
                        onChanged: (val) {
                          _searchList.clear();
                          for (var i in list) {
                            if (i.name
                                    .toLowerCase()
                                    .contains(val.toLowerCase()) ||
                                i.email
                                    .toLowerCase()
                                    .contains(val.toLowerCase())) {
                              _searchList.add(i);
                            }
                            setState(() {
                              _searchList;
                            });
                          }
                        },
                      )
                    : Text(
                        'Message',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      ),
              ),
            ],
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
                if (list.isNotEmpty) {
                  return ListView.builder(
                      itemCount:
                          _checkSearch ? _searchList.length : list.length,
                      padding: EdgeInsets.only(top: ms.height * 0.02),
                      itemBuilder: (context, index) {
                        return ChatUser(
                            user: _checkSearch
                                ? _searchList[index]
                                : list[index]);
                      });
                } else {
                  return const Center(
                    child:
                        Text('No connection', style: TextStyle(fontSize: 20)),
                  );
                }
            }
          },
        ));
  }
}
