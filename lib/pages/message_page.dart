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
      appBar: AppBar(
        title: const Text('Message'),
      ),
    );
  }

}