import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';

class Friendpage extends StatefulWidget{
  final String current_email_pg;
  const Friendpage({super.key,required this.current_email_pg});

  @override
  State<StatefulWidget> createState()  => _FriendPageState(this.current_email_pg);

}

class _FriendPageState extends State<Friendpage>{
  late double height, width;
  String name ='';
  String email_current='';
  _FriendPageState(String email)
  {
    this.email_current=email;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        title: Text(
          'Friend',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Theme.of(context).colorScheme.surfaceVariant
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
              color: Theme.of(context).colorScheme.onSurfaceVariant
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  child: TextField(
                    decoration: InputDecoration(

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.onSecondary,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.primaryContainer,),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondaryContainer,),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer),
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,

                    ),
                    onChanged: (val){
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                ),

                Text(email_current,style: TextStyle(color: Colors.black),),

            ],
          ),
      ),
    );
  }

  listviewfriend(String name) {

    if(name=='') {
      return Scaffold(

      );
    }
    else{
      return Scaffold(

      );
    }
  }

}