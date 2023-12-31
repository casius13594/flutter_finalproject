import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_finalproject/pages/phoneVerify_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_finalproject/apis/apis.dart';
import 'package:flutter_finalproject/apis/add_data.dart';
import 'package:http/http.dart' as http;

class ProfileEditing extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileEditingState();
}

class _ProfileEditingState extends State<ProfileEditing> {
  Uint8List? _image;

  final TextEditingController _controllerName = TextEditingController();
  bool _nameValidate = false;

  bool _isLoading = true;

  void selectImage() async {
    Uint8List img = await APIs().pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<Uint8List> getImageUint8List(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // If the request to the URL is successful, convert the response body (byte data) to Uint8List
      return Uint8List.fromList(response.bodyBytes);
    } else {
      // Handle error cases here, such as a 404 Not Found error
      throw Exception('Failed to load image');
    }
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    final imageUrl = await userSnapshot.get('image');
    final name = await userSnapshot.get('name');

    try {
      setState(() {
        _controllerName.text = name!;
      });
      if (imageUrl == null || imageUrl == 'null') {
        final unint8list = await getImageUint8List(
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png');
        setState(() {
          _image = unint8list;
          _isLoading = false; // Hide loading indicator
        });
      } else {
        final unint8list = await getImageUint8List(imageUrl);
        setState(() {
          _image = unint8list;
          _isLoading = false; // Hide loading indicator
        });
      }
      print('Name: $name');

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
    _initializeData();
  }

  void saveProfile() async {
    setState(() {
      _controllerName.text.isEmpty
          ? _nameValidate = true
          : _nameValidate = false;
    });

    if (!_nameValidate) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });
      String resp = await StoreData().saveData(
        name: _controllerName.text,
        file: _image!,
      );
      setState(() {
        _isLoading = false; // Show loading indicator
      });
      setState(() {});
      Fluttertoast.showToast(msg: resp);
    } else
      Fluttertoast.showToast(msg: 'Please recheck the field(s).');
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var padding = MediaQuery.of(context).padding;
    var safeHeight = height - padding.top - padding.bottom;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        colors: [Colors.lightBlueAccent, Colors.pinkAccent],
      )),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(children: [
                Container(
                  height: safeHeight * .3,
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(230),
                          bottomLeft: Radius.circular(230))),
                ),
                Container(
                  height: height - safeHeight * 0.3,
                  width: width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Theme.of(context).colorScheme.primaryContainer],
                      ),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(230),
                          topLeft: Radius.circular(230))),
                ),
              ]),
            ),

            SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      'Profile',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Stack(alignment: Alignment.center, children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 105,
                              backgroundImage: MemoryImage(_image!))
                          : CircularProgressIndicator(),
                      Positioned(
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                        bottom: -10,
                        right: 20,
                      ),
                    ]),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Display Name',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _controllerName,
                      decoration: InputDecoration(
                          errorText: _nameValidate
                              ? 'This field cannot be empty'
                              : null,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 2),
                          ),
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: saveProfile,
                        child: const Text('Save Profile',
                        style: TextStyle(color: Colors.black),))
                  ],
                ),
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
                : Container(), // Empty container when not loading
          ],
        ),
      ),
    );
  }
}
