import 'dart:ffi' as ffi;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/login_page.dart';
import 'package:flutter_finalproject/pages/profile_edit.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:flutter_finalproject/main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class changetheme {
  bool switcher = false;

  changetheme(this.switcher);

  bool get() {
    return switcher;
  }
}

class Settingpage extends StatefulWidget {
  const Settingpage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<Settingpage> {
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
                color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: Theme.of(context).colorScheme.surfaceVariant),
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
                  height: height * .73,
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
                              padding: EdgeInsets.only(left: 0, top: 0),
                              // image of profile
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage('lib/images/image_profile.jpg'),
                              ),
                            ),
                            SizedBox(width: 40),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // Adjust alignment as needed
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      FirebaseAuth
                                          .instance.currentUser!.displayName
                                          .toString(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                          fontSize: 40),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      FirebaseAuth.instance.currentUser!.email
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onTertiaryContainer,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Edit profile:',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileEditing()));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                  ))
                            ]),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              'Change theme:',
                              style: Theme.of(context).textTheme.headlineMedium,
                            )),
                            SizedBox(
                              width: 20,
                            ),
                            Switch(
                                value: MyApp.switcher.value,
                                onChanged: (newvalue) {
                                  setState(() {
                                    MyApp.switcher.value = newvalue;
                                  });
                                })
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onTertiary,
                            minimumSize: Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the radius as needed
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_back,
                            size: 32,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          label: Text(
                            'Sign Out',
                            style: TextStyle(
                                fontSize: 24,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                          ),
                          onPressed: () async {
                            GoogleSignIn _googleSignIn = GoogleSignIn();
                            await _googleSignIn.disconnect();
                            await FirebaseAuth.instance.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
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
    // return Drawer(
    //     backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
    //     child: SafeArea(
    //       maintainBottomViewPadding: false,
    //       child: Column(
    //         children: [
    //           Row(
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.only(left: 0, top: 0),
    //                 child: CircleAvatar(
    //                   radius: 30,
    //                   backgroundImage:
    //                       AssetImage('lib/images/image_profile.jpg'),
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: 20,
    //               ),
    //               Expanded(
    //                   child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 children: [
    //                   FittedBox(
    //                     fit: BoxFit.scaleDown,
    //                     child: Text(
    //                       FirebaseAuth.instance.currentUser!.displayName
    //                           .toString(),
    //                       style: TextStyle(
    //                           color: Theme.of(context)
    //                               .colorScheme
    //                               .onPrimaryContainer,
    //                           fontSize: 40),
    //                     ),
    //                   )
    //                 ],
    //               ))
    //             ],
    //           ),
    //         ],
    //       ),
    //     ));
  }
}
