import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/apis/apis.dart';
import 'package:flutter_finalproject/pages/create_password.dart';
import 'package:flutter_finalproject/pages/forgot_password_page.dart';
import 'package:flutter_finalproject/pages/register_page.dart';
import 'package:flutter_finalproject/pages/shifscreen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  _handleGoogleLogin() {
    _signInWithGoogle().then((user) async {
      log('\nUser: ${user.user}');
      log('\nUserAddtionalInfo: ${user.additionalUserInfo}');

      if (await APIs.checkUserExist()) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => shiftscreen()));
      } else {
        APIs.SelfInfo().then((value) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreatePasswordPage()));
        });
      }
    });
  }

  Future<UserCredential> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential authResult =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return authResult;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 30, bottom: 5),
                  child: SvgPicture.asset(
                    'lib/images/logo_login.svg',
                    width: 250,
                    height: 250,
                  ),
                ),

                Text(
                  "Welcome back",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
                //email text field
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 50, bottom: 5),
                  child: TextField(
                    controller: _controllerEmail,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Theme.of(context).colorScheme.primaryContainer,
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Theme.of(context).colorScheme.onBackground,
                        )),
                  ),
                ),

                // password
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 5, bottom: 5),
                  child: TextField(
                    controller: _controllerPassword,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: Theme.of(context).colorScheme.primaryContainer,
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'Password',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        prefixIcon: Icon(Icons.lock,
                            color: Theme.of(context).colorScheme.onBackground)),
                  ),
                ),
                //Forgot Password
                Padding(
                  padding: const EdgeInsets.only(right: 30, top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPassword()));
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // sign in button
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 25, top: 5, bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: TextButton(
                      onPressed: () {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _controllerEmail.text,
                                password: _controllerPassword.text)
                            .then((value) {
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid
                                  .toString())
                              .update({
                            'is_active': true,
                            'last_seen':
                                DateTime.now().microsecondsSinceEpoch.toString()
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => shiftscreen()));
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()} ");
                        });
                      },
                      style: TextButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.onTertiaryContainer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: 25, right: 20),
                      child: Divider(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        height: 36,
                      ),
                    )),
                    Text(
                      'Or',
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 20),
                    ),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(left: 20, right: 25),
                      child: Divider(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        height: 36,
                      ),
                    )),
                  ],
                ),

                GestureDetector(
                    onTap: () async {
                      if (GoogleSignIn().currentUser != null)
                        await GoogleSignIn().disconnect();
                      if (FirebaseAuth.instance.currentUser != null) {
                        await FirebaseAuth.instance.signOut();
                      }
                      _handleGoogleLogin();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.onPrimaryContainer),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SvgPicture.asset(
                          'lib/images/google_login.svg',
                          width: 40,
                          height: 40,
                        ))),

                // Not a member? Register
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member?',
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
