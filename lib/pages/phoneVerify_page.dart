import 'package:flutter/material.dart';

class PhoneVerify extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PhoneVerifyState();

}

class _PhoneVerifyState extends State<PhoneVerify>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

}