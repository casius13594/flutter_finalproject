import 'dart:async';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finalproject/apis/add_data.dart';
import 'package:flutter_finalproject/pages/login_page.dart';
import 'package:flutter_finalproject/pages/register_page.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_finalproject/apis/apis.dart';

class PhoneVerify extends StatefulWidget {
  String name = "";
  String email = "";

  PhoneVerify();

  PhoneVerify.withData(this.name);

  PhoneVerify.changeEmail(this.email);

  @override
  State<StatefulWidget> createState() => _PhoneVerifyState(name, email);
}

class _PhoneVerifyState extends State<PhoneVerify> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String name1 = "";
  String oldEmail = "";

  _PhoneVerifyState(String name, String email) {
    name1 = name;
    oldEmail = email;
  }

  late Timer _timerCheckVerified;

  @override
  void initState() {
    super.initState();
    isEmailVerified = auth.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      _timerCheckVerified = Timer.periodic(
        Duration(seconds: 2),
        (_) => checkEmailVerified(),
      );
    }
  }

  void reverseEmail() async {
    if (!isEmailVerified) {
      await auth.currentUser?.updateEmail(oldEmail);
      DocumentReference documentReference =
          firestore.collection('users').doc(auth.currentUser?.uid);
      await documentReference.update({
        'email': oldEmail,
      });
      Fluttertoast.showToast(msg: 'Email edition is reversed.');
    }
  }

  @override
  void dispose() {
    if (oldEmail != "") reverseEmail();
    _timerCheckVerified.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await auth.currentUser!.reload();
    setState(() {
      isEmailVerified = auth.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      _timerCheckVerified.cancel();
      if (name1 != "") await auth.currentUser?.updateDisplayName(name1);
      Fluttertoast.showToast(msg: 'Your email is successfully verified.');
      APIs.SelfInfo();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = auth.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? LoginPage()
      : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Email Verification'),
            titleTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
            iconTheme: IconThemeData(
                color: Colors.black),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('A verification email has been sent to your email.',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.email, size: 32),
                  label: Text(
                    'Resend Email',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () {
                    if (canResendEmail) {
                      sendVerificationEmail();
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Please wait and try again later');
                    }
                  },
                ),
                SizedBox(height: 8),
                TextButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50)),
                    onPressed: () {
                      auth.signOut();
                      _timerCheckVerified.cancel();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 24),
                    ))
              ],
            ),
          ),
        );
// @override
// Widget build(BuildContext context) {
//   final defaultPinTheme = PinTheme(
//     width: 56,
//     height: 56,
//     textStyle: TextStyle(
//         fontSize: 30,
//         color: Theme.of(context).colorScheme.onPrimaryContainer,
//         fontWeight: FontWeight.bold),
//     decoration: BoxDecoration(
//       border: Border.all(color:Theme.of(context).colorScheme.onPrimary,),
//       borderRadius: BorderRadius.circular(20),
//     ),
//   );
//
//   final focusedPinTheme = defaultPinTheme.copyDecorationWith(
//     border: Border.all(color: Theme.of(context).colorScheme.onPrimaryContainer),
//     borderRadius: BorderRadius.circular(8),
//   );
//
//   final submittedPinTheme = defaultPinTheme.copyWith(
//     decoration: defaultPinTheme.decoration?.copyWith(
//       color: Theme.of(context).colorScheme.onPrimaryContainer,
//     ),
//   );
//   var code = "";
//
//   return Container(
//     decoration: BoxDecoration(
//         gradient: RadialGradient(
//             radius: 0.2,
//             focal: Alignment(0, 0),
//             tileMode: TileMode.mirror,
//             colors: [Theme.of(context).colorScheme.tertiary,
//               Theme.of(context).colorScheme.onTertiary]
//         )
//     ),
//     child: Scaffold(
//         backgroundColor: Colors.transparent,
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             margin: EdgeInsets.symmetric(horizontal: 20),
//             padding: EdgeInsets.symmetric(horizontal: 5),
//
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(height: 100,),
//                 Text(
//                   'Phone Verification',
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSecondaryContainer,
//                     fontSize:  55,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//
//                 SizedBox(height: 50,),
//
//                 SizedBox(
//                   height: 300,
//                   width: 330,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.greenAccent,
//                             offset: const Offset(5.0, 5.0),
//                             blurRadius: 10.0,
//                             spreadRadius: 2.0,
//                           ), //BoxShadow
//                           BoxShadow(
//                             color: Colors.white,
//                             offset: const Offset(0.0, 0.0),
//                             blurRadius: 0.0,
//                             spreadRadius: 0.0,
//                           ), //BoxShadow
//                         ],
//                       borderRadius: BorderRadius.circular(10),
//                       image: DecorationImage(
//                         image: AssetImage('lib/images/phone_verify_lg.jpg'),
//                         fit:BoxFit.cover,
//                       )
//                     ),
//                   ),
//                 ),
//
//
//                 SizedBox(height: 50,),
//                 Pinput(
//                   length: 6,
//                   showCursor: true,
//                   onCompleted: (pin) => print(pin),
//                   onChanged: (value){
//                     code = value;
//                   },
//                 ),
//
//                 SizedBox(height: 20,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: SizedBox(
//                     width: double.infinity,
//                     height: 56,
//                     child: TextButton(
//                       onPressed: () async {
//
//                           PhoneAuthCredential credential = PhoneAuthProvider
//                               .credential(verificationId: RegisterPage.verify, smsCode: code);
//                           await auth.signInWithCredential(credential);
//                           FirebaseAuth.instance.createUserWithEmailAndPassword(
//                               email: email1,
//                               password: password1
//                           ).then((value) {
//                             Navigator.push(context,
//                                 MaterialPageRoute(builder: (context) => LoginPage()));
//                           }).onError((error, stackTrace) {
//                             print("Error ${error.toString()} ");
//                           });
//                           FirebaseFirestore.instance.collection('users').add({
//                             "name" : name1,
//                             "phone" : phone1,
//                             "email" : email1,
//                             "address" : address1
//                           });
//                       },
//                       style: TextButton.styleFrom(
//                           backgroundColor: Theme.of(context).colorScheme.tertiary,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)
//                           )
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Verify',
//                           style: TextStyle(
//                             color: Theme.of(context).colorScheme.onTertiary,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         )
//     ),
//   );
// }
}
