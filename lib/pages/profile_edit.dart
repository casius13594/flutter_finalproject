import 'package:flutter/material.dart';

class ProfileEditing extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _ProfileEditingState();

}

class _ProfileEditingState extends State<ProfileEditing>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],

        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,

        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
          ),
        ),
      ),

      body: ListView(

      ),

    );
  }
}