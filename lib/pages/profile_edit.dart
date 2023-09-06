import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
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

  final TextEditingController _controllerEmail = TextEditingController();
  bool _nameValidate = false;

  bool _emailValidate = false;
  String _emailError = '';

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
    final firestore = FirebaseFirestore.instance;
    DocumentReference documentReference = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid);
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    final imageUrl = await documentSnapshot.get('image');
    final email = await documentSnapshot.get('email');
    final unint8list = await getImageUint8List(imageUrl);
    final name = await documentSnapshot.get('name');
    try {
      setState(() {
        _controllerName.text = name;
        _image = unint8list;
        _controllerEmail.text = email;
        _isLoading = false; // Hide loading indicator
      });

      print('Email: $email');
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
    _initializeData();
    super.initState();
  }

  void saveProfile() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: _controllerEmail.text)
        .get();
    if (!querySnapshot.docs.isEmpty &&
        _controllerEmail.text != FirebaseAuth.instance.currentUser?.email) {
      _emailValidate = true;
      _emailError = "This email is already used for another account";
    } else {
      _emailValidate = false;
    }

    setState(() {
      _controllerName.text.isEmpty
          ? _nameValidate = true
          : _nameValidate = false;
      if (_controllerEmail.text.isEmpty) {
        _emailValidate = true;
        _emailError = 'This field cannot be empty';
      }
      if (!EmailValidator.validate(_controllerEmail.text)) {
        _emailValidate = true;
        _emailError = 'Please enter a valid email';
      }
    });

    if (!_nameValidate && !_emailValidate) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });
      String resp = await StoreData().saveData(
          name: _controllerName.text,
          file: _image!,
          email: _controllerEmail.text);
      setState(() {
        _isLoading = false; // Show loading indicator
      });
      Fluttertoast.showToast(msg: resp);
      if (resp == 'Please verify your new email') {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PhoneVerify()));
      }
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
        backgroundColor: Colors.grey[300],
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
                      color: Colors.red,
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
                        colors: [Colors.red, Colors.blueAccent],
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
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Stack(alignment: Alignment.center, children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 105,
                              backgroundImage: MemoryImage(_image!))
                          : CircleAvatar(
                              radius: 105,
                              backgroundImage: NetworkImage(
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                            ),
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
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
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
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                      decoration: InputDecoration(
                          errorText: _nameValidate
                              ? 'This field cannot be empty'
                              : null,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2),
                          ),
                          hintText: 'Name',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: _controllerEmail,
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                      decoration: InputDecoration(
                          errorText: _emailValidate ? _emailError : null,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 2),
                          ),
                          fillColor:
                              Theme.of(context).colorScheme.tertiaryContainer,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onTertiaryContainer),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: saveProfile,
                        child: const Text('Save Profile'))
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
