import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/friend_page.dart';
import 'package:flutter_finalproject/pages/home_page.dart';
import 'package:flutter_finalproject/pages/message_page.dart';
import 'package:flutter_finalproject/pages/setting_page.dart';


class shiftscreen extends StatefulWidget {
  String current_email ='';
  shiftscreen();
  shiftscreen.withData(this.current_email);
  @override
  State<shiftscreen> createState() => _shiftPageState(this.current_email);
}


class _shiftPageState extends State<shiftscreen>{
  int _selectedPageIndex = 0;
  late String current_email1='';
  _shiftPageState(String email)
  {
    this.current_email1 = email;
  }
  Widget getpage(int index) {
    switch (index){
      case 0:
        return Homepage();
        break;
      case 1:
        return MessagePage();
        break;
      case 2:
        return Friendpage(current_email_pg: this.current_email1);
        break;
      case 3:
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
        animationDuration: Duration(milliseconds: 300),
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