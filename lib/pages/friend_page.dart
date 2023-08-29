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

      appBar: AppBar(
        shadowColor: Colors.black45,
        title: Text(
          'Friends',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,

        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: (){},
        ),
        backgroundColor: Colors.black45,
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.add_card))
        ],

        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            gradient: LinearGradient(
              colors: [Colors.purple,Colors.red],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            )
          ),
        ),



      ),

      body: Stack(
        children: [
          Column(
            children:[
              Container(
                height: height * .1,
                decoration: BoxDecoration(
                    color: Colors.black45,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                color: Colors.black45,
                ),
                child: Container(
                  height: height* .73,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}