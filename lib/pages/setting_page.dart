import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/apis/add_data.dart';
import 'package:flutter_finalproject/apis/apis.dart';
import 'package:flutter_finalproject/pages/change_password.dart';
import 'package:flutter_finalproject/pages/login_page.dart';
import 'package:flutter_finalproject/pages/profile_edit.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:flutter_finalproject/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

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
  bool _isLoading = true;

  //changetheme _switch = changetheme(false);
  final _controllerName = TextEditingController();

  // Future<Uint8List> getImageUint8List(String imageUrl) async {
  //   final response = await http.get(Uri.parse(imageUrl));
  //
  //   if (response.statusCode == 200) {
  //     // If the request to the URL is successful, convert the response body (byte data) to Uint8List
  //     return Uint8List.fromList(response.bodyBytes);
  //   } else {
  //     // Handle error cases here, such as a 404 Not Found error
  //     throw Exception('Failed to load image');
  //   }
  // }

  Future<void> _initializeSettingData() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      _controllerName.text = userSnapshot.get('name');

      setState(() {
        _isLoading = false; // Hide loading indicator
      });
      // Now you have the image data as Uint8List, you can use it as needed.
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: 'Error: $e');
      setState(() {
        _isLoading = false; // Hide loading indicator on error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSettingData();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
        title: Text(
          'Setting',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Theme.of(context).colorScheme.surfaceVariant),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                height: height * .8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator(); // Display a loading indicator
                          }
                          if (snapshot.hasError) {
                            return Text('Error snapshot: ${snapshot.error}');
                          }

                          return Column(
                            children: [
                              // Show profile in settings
                              Padding(
                                padding: EdgeInsets.only(left: 0, top: 0),
                                // image of profile
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage(
                                    (snapshot.data!.data() as Map<String,
                                                    dynamic>?)?['image'] ==
                                                null ||
                                            (snapshot.data!.data() as Map<
                                                    String,
                                                    dynamic>?)?['image'] ==
                                                'null'
                                        ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
                                        : (snapshot.data!.data()
                                            as Map<String, dynamic>?)?['image'],
                                  ),
                                ),
                              ),
                              SizedBox(width: 30, height: 30),

                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  (snapshot.data!.data()
                                          as Map<String, dynamic>?)?['name'] ??
                                      'No name',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 5),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  (snapshot.data!.data()
                                          as Map<String, dynamic>?)?['email'] ??
                                      'No email',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 5,
                              ), // Adjust the spacing as needed
                              Divider(
                                thickness: 1,
                                // Adjust the thickness of the line as needed
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant, // Adjust the color of the line as needed
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Edit profile:',
                                      style: TextStyle(fontSize: 20),
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
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(
                                    'Change theme:',
                                    style: TextStyle(fontSize: 20),
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

                              SizedBox(
                                height: 40,
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onTertiary,
                                  minimumSize: Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors
                                            .black, // Set the border color
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(20),
                                    // Adjust the radius as needed
                                  ),
                                ),
                                icon: Icon(
                                  Icons.password,
                                  size: 32,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                                label: Text(
                                  'Change Password',
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePasswordPage()));
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.onTertiary,
                                  minimumSize: Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors
                                            .black, // Set the border color
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.arrow_back,
                                  size: 32,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
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
                                  APIs.updateStatusActive(false);
                                  GoogleSignIn _googleSignIn = GoogleSignIn();
                                  if (_googleSignIn.currentUser != null)
                                    await _googleSignIn.disconnect();
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                              ),
                            ],
                          );
                        })),
              ),
            ),
            _isLoading
                ? Container(
                    color:
                        Colors.black.withOpacity(0.5), // Darken the background
                    child: Center(
                      child: CircularProgressIndicator(), // Loading indicator
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
