import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/phoneVerify_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dart:core';
import 'package:email_validator/email_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _nameValidate = false;

  bool _emailValidate = false;
  bool _passwordValidate = false;
  String _emailError = '';

  String _passwordError = '';
  CountryCode selectedCountry = CountryCode(
      name: "Việt Nam", flagUri: "flags/vn.png", code: "VN", dialCode: "+84");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Create Account'),
          titleTextStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 20,
              fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(
              color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Full name
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
                      errorText:
                          _nameValidate ? 'This field cannot be empty' : null,
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
                // Email
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Email',
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
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                      errorText: _emailValidate ? _emailError : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 2),
                      ),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                ),

                SizedBox(
                  height: 20,
                ),
                //Password
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Password',
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
                  controller: _controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      errorText: _passwordValidate ? _passwordError : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 2),
                      ),
                      fillColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                ),

                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        // Align the button to the right
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: ElevatedButton.icon(
                              icon: Icon(Icons.arrow_circle_right),
                              label: Text("Let's sign up"),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(5),
                                fixedSize: Size(150, 50),
                              ),
                              onPressed: () async {
                                if (FirebaseAuth.instance.currentUser != null) {
                                  await FirebaseAuth.instance.signOut();
                                }
                                if (GoogleSignIn().currentUser != null) {
                                  await GoogleSignIn().disconnect();
                                }
                                QuerySnapshot querySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .where('email',
                                            isEqualTo: _controllerEmail.text)
                                        .get();
                                if (!querySnapshot.docs.isEmpty) {
                                  _emailValidate = true;
                                  _emailError =
                                      "This email is already used for another account";
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
                                  if (!EmailValidator.validate(
                                      _controllerEmail.text)) {
                                    _emailValidate = true;
                                    _emailError = 'Please enter a valid email';
                                  }
                                  if (_controllerPassword.text.length < 6) {
                                    _passwordValidate = true;
                                    _passwordError =
                                        "Password length must be at least 6 characters";
                                  } else
                                    _passwordValidate = false;
                                });

                                if (!_nameValidate &&
                                    !_passwordValidate &&
                                    !_emailValidate) {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: _controllerEmail.text.trim(),
                                          password:
                                              _controllerPassword.text.trim())
                                      .then((value) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PhoneVerify.withData(
                                                    _controllerName.text)));
                                  });
                                } else
                                  Fluttertoast.showToast(
                                      msg: 'Please check the field(s) again.');
                              }),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
