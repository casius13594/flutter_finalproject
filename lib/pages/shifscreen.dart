import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/friend_page.dart';
import 'package:flutter_finalproject/pages/home_page.dart';
import 'package:flutter_finalproject/pages/message_page.dart';
import 'package:flutter_finalproject/pages/setting_page.dart';


class shiftscreen extends StatefulWidget {
  const shiftscreen({super.key});

  @override
  State<shiftscreen> createState() => _shiftPageState();
}

class _shiftPageState extends State<shiftscreen>{
  int _selectedPageIndex = 0;
  List page = [
    Homepage(),
    MessagePage(),
    Friendpage(),
    Settingpage()
  ];
  void _OnItemCLick(int index) async {
    setState(() {
      _selectedPageIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[_selectedPageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.deepPurple,
        color: Colors.deepPurple.shade400,
        animationDuration: Duration(milliseconds: 300),
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.message,
            color: Colors.white,
          ),
          Icon(
            Icons.mobile_friendly,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ],
        onTap: (index){
          _OnItemCLick(index);
        },

      ),
      );
  }

}