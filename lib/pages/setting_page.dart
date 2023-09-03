import 'dart:ffi' as ffi;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/login_page.dart';
import 'package:flutter_finalproject/pages/profile_edit.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:flutter_finalproject/main.dart';
import 'package:google_sign_in/google_sign_in.dart';


class changetheme{
  bool switcher = false;

  changetheme(this.switcher);

  bool get() {
    return switcher;
  }
}

class Settingpage extends StatefulWidget{
  const Settingpage({super.key});

  @override
  State<StatefulWidget> createState()  => _SettingPageState();

}

class _SettingPageState extends State<Settingpage>{
  late double height, width;

  changetheme _switch = changetheme(false);


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
          'Setting',
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

                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    children: [
                      // Show profile in settings
                      Row(
                        children: [

                          Padding(
                            padding: EdgeInsets.only(left: 0,top: 0),

                            // image of profile
                            child:  CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('lib/images/image_profile.jpg'),
                            ),
                          ),

                          SizedBox(width: 40,),

                          Column(
                            children: [
                              Text(
                                'My name',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  fontSize: 40,
                                ),),

                              SizedBox(height: 5,),

                              Text(
                                'abcdzyz.@gmail.com',
                                style:TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: 40,),

                          SizedBox(
                            // button for editing profile
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.transparent,
                                  elevation: 0
                              ),
                              onPressed: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProfileEditing())
                                );
                              },
                              child: Icon(
                                Icons.edit,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          )

                        ],
                      ),

                      Row(
                        children: [
                          Text('Change theme:',
                            style: Theme.of(context).textTheme.headlineMedium,),

                          SizedBox(width: 20,),

                          Switch(value: MyApp.switcher.value,
                              onChanged: (newvalue){
                                setState(() {
                                  MyApp.switcher.value = newvalue;
                                });
                              })
                        ],

                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.fromHeight(50),
                          ),
                          icon: Icon(Icons.arrow_back, size: 32),
                          label: Text(
                            'Sign Out',
                            style: TextStyle(fontSize: 24),
                          ),
                          onPressed: () async {
                            GoogleSignIn _googleSignIn = GoogleSignIn();
                            await _googleSignIn.disconnect();
                            await FirebaseAuth.instance.signOut();
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}