import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';

class Friendpage extends StatefulWidget{
  const Friendpage({super.key});

  @override
  State<StatefulWidget> createState()  => _FriendPageState();

}

class _FriendPageState extends State<Friendpage>{
  late double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        title: Text(
          'Friend',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Theme.of(context).colorScheme.onSurfaceVariant
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant
          ),
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: false,
        child: Stack(
          children: [

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: width,
                height: height* .73,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),

                child: Container(),),
            ),
          ],
        ),
      ),
    );
  }

}