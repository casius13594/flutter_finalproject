import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';

class Friendpage extends StatefulWidget{
  const Friendpage({super.key});

  @override
  State<StatefulWidget> createState()  => _FriendPageState();

}

class _FriendPageState extends State<Friendpage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend'),
      ),
    );
  }

}