import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/friend_page.dart';
import 'package:flutter_finalproject/pages/search_page.dart';
import 'package:flutter_finalproject/pages/home_page.dart';
import 'package:flutter_finalproject/pages/message_page.dart';
import 'package:flutter_finalproject/pages/setting_page.dart';


class shiftscreen extends StatefulWidget {
  shiftscreen();
  @override
  State<shiftscreen> createState() => _shiftPageState();
}


class _shiftPageState extends State<shiftscreen>{
  int _selectedPageIndex = 0;
  Widget getpage(int index) {
    switch (index){
      case 0:
        return Homepage();
        break;
      case 1:
        return MessagePage();
        break;
      case 2:
        return FriendPage();
        break;
      case 3:
        return SearchPage();
        break;
      case 4:
        return Settingpage();
        break;
      default:
        return Homepage();
        break;
    }
  }

  void _OnItemCLick(int index) async {
    setState(() {
      _selectedPageIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getpage(_selectedPageIndex),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        animationDuration: Duration(milliseconds: 200),
        items: [
          Icon(
            Icons.home,
            color: Colors.black,
          ),
          Icon(
            Icons.message,
            color: Colors.black,
          ),
          Icon(
            Icons.mobile_friendly,
            color: Colors.black,
          ),
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          Icon(
            Icons.settings,
            color: Colors.black,
          ),
        ],
        onTap: (index){
          _OnItemCLick(index);
        },
      ),
    );
  }

}