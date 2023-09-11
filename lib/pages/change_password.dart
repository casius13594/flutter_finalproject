import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/pages/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _controllerNewPassword = TextEditingController();
  final _controllerCurrentPassword = TextEditingController();
  bool _passwordValidateNew = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(
              radius: 0.6,
              focalRadius: 0.17,
              focal: Alignment(0.3, -0.3),
              tileMode: TileMode.mirror,
              colors: [
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.onTertiary
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Change \nPassword',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiaryContainer,
                    fontSize: 55,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Current password',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _controllerCurrentPassword,
                  obscureText: true,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiaryContainer),
                  decoration: InputDecoration(
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
                      hintText: 'Current Password',
                      hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                ),
                //Password
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'New password',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: _controllerNewPassword,
                  obscureText: true,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiaryContainer),
                  decoration: InputDecoration(
                      errorText: _passwordValidateNew
                          ? 'Password length must be at least 6 characters'
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
                      hintText: 'New Password',
                      hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onTertiaryContainer),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                ),
                SizedBox(
                  height: 5,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                            icon: Icon(Icons.arrow_circle_right),
                            label: Text("Confirm"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(5),
                              fixedSize: Size(100, 50),
                              shadowColor:
                                  Theme.of(context).colorScheme.onBackground,
                              side: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  width: 2),
                              backgroundColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                            onPressed: () async {
                              setState(() {
                                _controllerNewPassword.text.length < 6
                                    ? _passwordValidateNew = true
                                    : _passwordValidateNew = false;
                              });
                              if (!_passwordValidateNew) {
                                try {
                                  final user =
                                      await FirebaseAuth.instance.currentUser;
                                  if (user != null && _controllerCurrentPassword.text != '') {
                                    final AuthCredential credential =
                                        EmailAuthProvider.credential(
                                      email: user.email.toString(),
                                      password: _controllerCurrentPassword.text,
                                    );
                                    await user.reauthenticateWithCredential(
                                        credential);
                                    await FirebaseAuth.instance.currentUser!
                                        .updatePassword(
                                        _controllerNewPassword.text)
                                        .then((value) async {
                                      Fluttertoast.showToast(
                                          msg:
                                          'Successfully changed password. Please login again');
                                      GoogleSignIn _googleSignIn = GoogleSignIn();
                                      await _googleSignIn.disconnect();
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LoginPage()));
                                    });
                                  } else {
                                    Fluttertoast.showToast(msg: "Current password is null.");
                                  }
                                } on FirebaseAuthException catch (e) {
                                  Fluttertoast.showToast(
                                      msg:
                                      "Error re-authenticating user: ${e.message.toString()}");
                                }catch (e){
                                  Fluttertoast.showToast(
                                      msg:
                                      "Error changing password: $e");
                                }
                              }
                            })))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
