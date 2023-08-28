import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';

class Settingpage extends StatefulWidget{
  const Settingpage({super.key});

  @override
  State<StatefulWidget> createState()  => _SettingPageState();

}

class _SettingPageState extends State<Settingpage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
    );
  }

}