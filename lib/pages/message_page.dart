import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';

class MessagePage extends StatefulWidget{
  const MessagePage({super.key});

  @override
  State<StatefulWidget> createState()  => _MessagePageState();

}

class _MessagePageState extends State<MessagePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: Text('Message'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false,
      ),
    );
  }

}