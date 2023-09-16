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

class _shiftPageState extends State<shiftscreen> {
  int _selectedPageIndex = 0;
  Widget getpage(int index) {
    switch (index) {
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
    ms = MediaQuery.of(context).size;
    return Scaffold(
      body: getpage(_selectedPageIndex),
      bottomNavigationBar: CurvedNavigationBar(
        height: ms.height * .07,
        backgroundColor: Colors.white,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        animationDuration: Duration(milliseconds: 200),
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
            Icons.search,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          _OnItemCLick(index);
        },
      ),
    );
  }
}
